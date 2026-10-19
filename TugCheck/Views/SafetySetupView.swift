import SwiftUI

struct SafetySetupView: View {
    let people: [Person]
    @Binding var selectedPersonID: UUID?
    @Binding var usedWalkingAid: Bool
    @Binding var checks: [Bool]
    var onStart: () -> Void
    var onClose: () -> Void
    var onAddPerson: () -> Void

    @Environment(\.colorSchemeContrast) private var contrast

    private let checkText: [String] = [
        Copy.checkChair,
        Copy.checkPath,
        Copy.checkShoes,
        Copy.checkHelper
    ]

    private var allChecked: Bool {
        checks.count == checkText.count && checks.allSatisfy { $0 }
    }

    private var canStart: Bool {
        selectedPersonID != nil && allChecked
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                LargeButton(title: Copy.close, hint: nil) {
                    onClose()
                }

                Text(Copy.helperHoldsPhone)
                    .font(.body)
                    .foregroundStyle(.primary)

                if people.isEmpty {
                    Text(Copy.addPersonBeforeStart)
                        .font(.body)
                    LargeButton(title: Copy.addPerson, hint: Copy.managePeopleHint, prominent: true) {
                        onAddPerson()
                    }
                } else {
                    Text(Copy.person)
                        .font(.headline)
                    Picker(Copy.person, selection: $selectedPersonID) {
                        ForEach(people) { person in
                            Text(person.name).tag(Optional(person.id))
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                    .accessibilityLabel(Copy.person)

                    Toggle(isOn: $usedWalkingAid) {
                        Text(Copy.walkingAidUsed)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(minHeight: 60)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary, lineWidth: contrast == .increased ? 2 : 1)
                    )
                    .accessibilityLabel(Copy.walkingAidUsed)
                    .accessibilityValue(Copy.yesNo(usedWalkingAid))

                    LargeButton(title: Copy.addPerson, hint: Copy.managePeopleHint) {
                        onAddPerson()
                    }
                }

                Text(Copy.helperConfirms)
                    .font(.body)
                    .foregroundStyle(.primary)

                ForEach(checkText.indices, id: \.self) { index in
                    CheckButton(
                        title: checkText[index],
                        hint: checks[index] ? Copy.tickedHint : Copy.untickedHint,
                        isOn: checks[index]
                    ) {
                        var next = checks
                        next[index].toggle()
                        checks = next
                    }
                }

                Text(Copy.readAloudTitle)
                    .font(.title2)
                Text(Copy.readAloud)
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary, lineWidth: contrast == .increased ? 3 : 1)
                    )
                    .accessibilityLabel("\(Copy.readAloudTitle). \(Copy.readAloud)")

                if !canStart {
                    Text(people.isEmpty ? Copy.addPersonBeforeStart : Copy.tickEveryItem)
                        .font(.body)
                        .foregroundStyle(.primary)
                }

                LargeButton(
                    title: Copy.start,
                    hint: canStart ? Copy.startHint : Copy.tickEveryItem,
                    prominent: true
                ) {
                    onStart()
                }
                .disabled(!canStart)
            }
            .padding()
        }
    }
}
