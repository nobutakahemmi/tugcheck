import XCTest
@testable import TugCheck

final class ManualClock {
    var time: TimeInterval
    init(time: TimeInterval) {
        self.time = time
    }
}

final class TimerServiceTests: XCTestCase {
    func testElapsedIsZeroBeforeStart() {
        let clock = ManualClock(time: 40)
        let watch = MonotonicStopwatch(now: { clock.time })
        XCTAssertEqual(watch.elapsed(), 0)
        XCTAssertFalse(watch.isRunning)
    }

    func testElapsedFollowsInjectedClock() {
        let clock = ManualClock(time: 10)
        var watch = MonotonicStopwatch(now: { clock.time })
        watch.start()
        XCTAssertTrue(watch.isRunning)
        clock.time = 22.5
        XCTAssertEqual(watch.elapsed(), 12.5, accuracy: 0.000_001)
        let stopped = watch.stop()
        XCTAssertEqual(stopped, 12.5, accuracy: 0.000_001)
        XCTAssertFalse(watch.isRunning)
        clock.time = 80
        XCTAssertEqual(watch.elapsed(), 12.5, accuracy: 0.000_001)
    }

    func testStopBeforeStartReturnsZero() {
        var watch = MonotonicStopwatch(now: { 5 })
        XCTAssertEqual(watch.stop(), 0)
    }

    func testClockMovingBackwardClampsToZero() {
        let clock = ManualClock(time: 10)
        var watch = MonotonicStopwatch(now: { clock.time })
        watch.start()
        clock.time = 4
        XCTAssertEqual(watch.elapsed(), 0)
    }

    func testStartResetsPreviousAttempt() {
        let clock = ManualClock(time: 0)
        var watch = MonotonicStopwatch(now: { clock.time })
        watch.start()
        clock.time = 5
        watch.stop()
        clock.time = 9
        watch.start()
        clock.time = 12
        XCTAssertEqual(watch.elapsed(), 3, accuracy: 0.000_001)
    }

    func testProductionClockIsMonotonicAndNotWallTime() {
        let first = MonotonicClock.now()
        let second = MonotonicClock.now()
        XCTAssertGreaterThanOrEqual(first, 0)
        XCTAssertGreaterThanOrEqual(second, first)
        XCTAssertLessThan(second, 10_000_000)
    }

    func testTimerStartsWhenGoIsSpokenAndStopsAtOneDecimal() async {
        await MainActor.run {
            let clock = ManualClock(time: 50)
            let runner = TestRunner(now: { clock.time })
            XCTAssertNil(runner.stop())
            runner.noteGoWasSpoken()
            clock.time = 61.25
            let seconds = runner.stop()
            XCTAssertEqual(seconds ?? -1, 11.3, accuracy: 0.001)
            guard case .finished(let value) = runner.phase else {
                return XCTFail("Expected a finished attempt")
            }
            XCTAssertEqual(value, 11.3, accuracy: 0.001)
            XCTAssertEqual(ResultFormatting.formatSeconds(value), "11.3")
        }
    }

    func testSpeakingGoTwiceDoesNotRestartTheClock() async {
        await MainActor.run {
            let clock = ManualClock(time: 50)
            let runner = TestRunner(now: { clock.time })
            runner.noteGoWasSpoken()
            clock.time = 55
            runner.noteGoWasSpoken()
            clock.time = 60
            XCTAssertEqual(runner.elapsed(), 10, accuracy: 0.001)
        }
    }

    func testCancelDiscardsTheAttempt() async {
        await MainActor.run {
            let clock = ManualClock(time: 3)
            let runner = TestRunner(now: { clock.time })
            runner.noteGoWasSpoken()
            clock.time = 8
            runner.cancel()
            XCTAssertEqual(runner.phase, .cancelled)
            XCTAssertNil(runner.stop())
            runner.noteGoWasSpoken()
            XCTAssertEqual(runner.phase, .cancelled)
        }
    }
}
