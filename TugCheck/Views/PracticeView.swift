import SwiftUI

struct PracticeView: View {
    var onDone: () -> Void
    var onClose: () -> Void

    @State private var stepIndex: Int?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                LargeButton(title: Copy.backToSetup, hint: nil) {
                    onClose()
                }

                Text(Copy.practiceIntro)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(Copy.helperHoldsPhone)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(Copy.readAloud)
                    .font(.title3)
                    .foregroundStyle(.primary)

                if let stepIndex {
                    let step = Copy.practiceSteps[stepIndex]
                    let progress = Copy.practiceProgress(
                        current: stepIndex + 1,
                        total: Copy.practiceSteps.count
                    )
                    Text(progress)
                        .font(.title2)
                    Text(step)
                        .font(.title)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                        .accessibilityLabel("\(progress). \(step)")

                    if stepIndex + 1 < Copy.practiceSteps.count {
                        LargeButton(title: Copy.nextStep, hint: nil) {
                            self.stepIndex = stepIndex + 1
                        }
                    } else {
                        Text(Copy.practiceReady)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                }

                LargeButton(
                    title: Copy.startPractice,
                    hint: Copy.practiceIntro,
                    prominent: stepIndex == nil
                ) {
                    stepIndex = 0
                }

                LargeButton(title: Copy.doneStartTimed, hint: nil, prominent: true) {
                    onDone()
                }
            }
            .padding()
        }
    }
}
