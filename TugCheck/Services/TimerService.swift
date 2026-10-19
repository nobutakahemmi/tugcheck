import Foundation

/// Monotonic time based on ContinuousClock. This is not wall-clock Date time,
/// so a clock change during a walk cannot stretch or shrink the result.
enum MonotonicClock {
    private static let shared = ContinuousMonotonicClock()

    static func now() -> TimeInterval {
        shared.now()
    }
}

final class ContinuousMonotonicClock {
    private let clock = ContinuousClock()
    private let origin: ContinuousClock.Instant

    init() {
        origin = clock.now
    }

    func now() -> TimeInterval {
        let parts = origin.duration(to: clock.now).components
        return Double(parts.seconds) + Double(parts.attoseconds) / 1_000_000_000_000_000_000
    }
}

/// Measures one attempt. Tests pass a fake `now` closure; the app uses MonotonicClock.
struct MonotonicStopwatch {
    private let now: () -> TimeInterval
    private var startedAt: TimeInterval?
    private var stoppedAt: TimeInterval?

    init(now: @escaping () -> TimeInterval = { MonotonicClock.now() }) {
        self.now = now
    }

    var isRunning: Bool {
        startedAt != nil && stoppedAt == nil
    }

    mutating func start() {
        startedAt = now()
        stoppedAt = nil
    }

    @discardableResult
    mutating func stop() -> TimeInterval {
        guard startedAt != nil else { return 0 }
        if stoppedAt == nil {
            stoppedAt = now()
        }
        return elapsed()
    }

    func elapsed() -> TimeInterval {
        guard let startedAt else { return 0 }
        let end = stoppedAt ?? now()
        return max(0, end - startedAt)
    }
}
