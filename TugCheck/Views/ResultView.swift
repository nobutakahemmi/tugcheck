import SwiftData
import SwiftUI

struct ResultView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorSchemeContrast) private var contrast

    let person: Person
    let seconds: Double
    let usedWalkingAid: Bool
    var onSave: () -> Void
    var onDiscard: () -> Void
    var onRetake: () -> Void

    @State private var note = ""
    @State private var selected: Set<String> = []
    @State private var showSaveError = false
    @ScaledMetric(relativeTo: .largeTitle) private var resultSize: CGFloat = 72

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(ResultFormatting.formatSeconds(seconds))
                    .font(.system(size: resultSize, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                    .accessibilityLabel(ResultFormatting.listSeconds(seconds))

                Text(Copy.seconds)
                    .font(.title2)

                Text(ResultFormatting.walkingAidText(used: usedWalkingAid))
                    .font(.body)

                Text(Copy.cdcReference)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)

                Text(Copy.cutOffNote)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)

                Text(Copy.optionalNote)
                    .font(.headline)
                TextField(Copy.optionalNote, text: $note, axis: .vertical)
                    .lineLimit(3...6)
                    .font(.body)
                    .borderedField()
                    .accessibilityLabel(Copy.optionalNote)

                Text(Copy.observations)
                    .font(.title2)
                Text(Copy.observationsHelp)
                    .font(.body)
                    .foregroundStyle(contrast == .increased ? Color.primary : Color.secondary)

                ForEach(MobilityObservation.allCases) { item in
                    let isOn = selected.contains(item.label)
                    CheckButton(
                        title: item.label,
                        hint: isOn ? Copy.tickedHint : Copy.observationsHelp,
                        isOn: isOn
                    ) {
                        if isOn {
                            selected.remove(item.label)
                        } else {
                            selected.insert(item.label)
                        }
                    }
                }

                LargeButton(title: Copy.save, hint: Copy.saveHint, prominent: true) {
                    save()
                }
                LargeButton(title: Copy.retake, hint: Copy.retakeHint) {
                    onRetake()
                }
                LargeButton(title: Copy.discard, hint: Copy.discardHint, role: .destructive) {
                    onDiscard()
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .alert(Copy.couldNotSave, isPresented: $showSaveError) {
            Button(Copy.done, role: .cancel) {}
        }
    }

    private func save() {
        let trimmed = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let result = TestResult(
            seconds: seconds,
            usedWalkingAid: usedWalkingAid,
            note: trimmed.isEmpty ? nil : trimmed,
            observations: MobilityObservation.ordered(selected),
            person: person
        )
        modelContext.insert(result)
        do {
            try modelContext.save()
            onSave()
        } catch {
            showSaveError = true
        }
    }
}
