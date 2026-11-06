import Combine
import Foundation
import UIKit

/// Countdown, spoken "Go", and the measured walk.
/// The monotonic timer starts in `noteGoWasSpoken`, which runs when speech starts
/// (or shortly after, if the speaker never begins).
@MainActor
final class TestRunner: ObservableObject {
    enum Phase: Equatable {
        case countdown(Int)
        case go
        case running
        case finished(Double)
        case cancelled
    }

    @Published private(set) var phase: Phase = .countdown(3)

    private var stopwatch: MonotonicStopwatch
    private var countdownTask: Task<Void, Never>?
    private var watchdog: Task<Void, Never>?
    private var speech: SpeechService?
    private var haptic: UIImpactFeedbackGenerator?
    private var didStartRunning = false
    private var didBeginCountdown = false

    init(now: @escaping () -> TimeInterval = { MonotonicClock.now() }) {
        stopwatch = MonotonicStopwatch(now: now)
    }

    func elapsed() -> TimeInterval {
        stopwatch.elapsed()
    }

    func beginCountdown() {
        guard !didBeginCountdown else { return }
        didBeginCountdown = true
        UIApplication.shared.isIdleTimerDisabled = true
        prepareHaptic()
        countdownTask?.cancel()
        countdownTask = Task { [weak self] in
            guard let self else { return }
            for number in [3, 2, 1] {
                self.phase = .countdown(number)
                UIAccessibility.post(notification: .announcement, argument: String(number))
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    return
                }
                if Task.isCancelled { return }
            }
            self.speakGo()
        }
    }

    func noteGoWasSpoken() {
        guard !didStartRunning else { return }
        switch phase {
        case .cancelled, .finished:
            return
        case .countdown, .go, .running:
            break
        }
        didStartRunning = true
        watchdog?.cancel()
        stopwatch.start()
        phase = .running
        impact()
        UIAccessibility.post(notification: .announcement, argument: Copy.go)
    }

    func stop() -> Double? {
        guard case .running = phase else { return nil }
        watchdog?.cancel()
        let seconds = ResultFormatting.roundedSeconds(stopwatch.stop())
        phase = .finished(seconds)
        impact()
        UIApplication.shared.isIdleTimerDisabled = false
        UIAccessibility.post(notification: .announcement, argument: Copy.stop)
        return seconds
    }

    func cancel() {
        countdownTask?.cancel()
        watchdog?.cancel()
        speech?.stop()
        phase = .cancelled
        UIApplication.shared.isIdleTimerDisabled = false
    }

    /// Leaves the screen. Restores the idle timer without changing a finished result.
    func end() {
        countdownTask?.cancel()
        watchdog?.cancel()
        speech?.stop()
        UIApplication.shared.isIdleTimerDisabled = false
    }

    private func speakGo() {
        guard !didStartRunning else { return }
        phase = .go
        prepareHaptic()
        let speaker = speech ?? SpeechService()
        speech = speaker
        speaker.onSpeakStarted = { [weak self] text in
            guard text == Copy.go else { return }
            Task { @MainActor in
                self?.noteGoWasSpoken()
            }
        }
        speaker.speak(Copy.go)
        watchdog?.cancel()
        watchdog = Task { [weak self] in
            do {
                try await Task.sleep(for: .milliseconds(1200))
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            self?.noteGoWasSpoken()
        }
    }

    private func prepareHaptic() {
        let generator = haptic ?? UIImpactFeedbackGenerator(style: .heavy)
        haptic = generator
        generator.prepare()
    }

    private func impact() {
        prepareHaptic()
        haptic?.impactOccurred()
    }
}
