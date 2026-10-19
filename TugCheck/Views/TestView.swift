import SwiftUI

struct TestView: View {
    var onFinished: (Double) -> Void
    var onCancel: () -> Void

    @StateObject private var runner = TestRunner()
    @ScaledMetric(relativeTo: .largeTitle) private var timerSize: CGFloat = 80

    var body: some View {
        VStack(spacing: 20) {
            LargeButton(
                title: Copy.cancelAttempt,
                hint: Copy.discardAttemptHint,
                role: .cancel
            ) {
                runner.cancel()
                onCancel()
            }

            Spacer(minLength: 12)
            readout
            Spacer(minLength: 12)

            if case .running = runner.phase {
                Text(Copy.stopWhenSeated)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                LargeButton(
                    title: Copy.stop,
                    hint: Copy.stopWhenSeated,
                    prominent: true,
                    tint: .red
                ) {
                    if let seconds = runner.stop() {
                        onFinished(seconds)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            runner.beginCountdown()
        }
        .onDisappear {
            runner.end()
        }
    }

    @ViewBuilder
    private var readout: some View {
        switch runner.phase {
        case .countdown(let number):
            VStack(spacing: 8) {
                Text(Copy.getReady)
                    .font(.title2)
                Text(String(number))
                    .font(.system(size: timerSize, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.3)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(Copy.countdown) \(number)")
        case .go:
            Text(Copy.go)
                .font(.system(size: timerSize, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.3)
                .lineLimit(1)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, minHeight: 60)
                .accessibilityLabel(Copy.go)
        case .running, .finished, .cancelled:
            TimelineView(.periodic(from: .now, by: 0.1)) { _ in
                let formatted = ResultFormatting.formatSeconds(runner.elapsed())
                VStack(spacing: 8) {
                    Text(formatted)
                        .font(.system(size: timerSize, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                        .foregroundStyle(.primary)
                    Text(Copy.seconds)
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(Copy.elapsedTime) \(formatted) \(Copy.seconds)")
                .accessibilityAddTraits(.updatesFrequently)
            }
        }
    }
}
