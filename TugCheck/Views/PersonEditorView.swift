import SwiftData
import SwiftUI

struct PersonEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let person: Person?

    @State private var name: String
    @State private var includeBirthYear: Bool
    @State private var birthYear: Int
    @State private var confirmDelete = false
    @State private var showSaveError = false

    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }

    init(person: Person?) {
        self.person = person
        let yearNow = Calendar.current.component(.year, from: Date())
        let storedYear = person?.birthYear
        _name = State(initialValue: person?.name ?? "")
        _includeBirthYear = State(initialValue: storedYear != nil)
        let fallback = min(max(storedYear ?? 1950, 1900), yearNow)
        _birthYear = State(initialValue: fallback)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(Copy.name)
                    .font(.headline)
                TextField(Copy.name, text: $name)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .font(.body)
                    .borderedField()
                    .accessibilityLabel(Copy.name)

                Toggle(isOn: $includeBirthYear) {
                    Text(Copy.includeBirthYear)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(minHeight: 60)
                .accessibilityLabel(Copy.includeBirthYear)
                .accessibilityValue(Copy.yesNo(includeBirthYear))

                if includeBirthYear {
                    Stepper(value: $birthYear, in: 1900...currentYear) {
                        Text(verbatim: "\(Copy.birthYear): \(String(birthYear))")
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(minHeight: 60)
                    .accessibilityLabel(Copy.birthYear)
                    .accessibilityValue(String(birthYear))
                }

                LargeButton(
                    title: Copy.save,
                    hint: Copy.saveHint,
                    prominent: true
                ) {
                    save()
                }
                .disabled(trimmedName.isEmpty)

                if person != nil {
                    LargeButton(
                        title: Copy.delete,
                        hint: Copy.deletePersonHint,
                        role: .destructive
                    ) {
                        confirmDelete = true
                    }
                }

                LargeButton(title: Copy.cancel, hint: nil) {
                    dismiss()
                }
            }
            .padding()
        }
        .navigationTitle(person == nil ? Copy.addPerson : Copy.editPerson)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .confirmationDialog(
            Copy.deletePersonTitle,
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button(Copy.delete, role: .destructive) {
                deletePerson()
            }
            Button(Copy.cancel, role: .cancel) {}
        } message: {
            Text(Copy.deletePersonMessage)
        }
        .alert(Copy.couldNotSavePerson, isPresented: $showSaveError) {
            Button(Copy.done, role: .cancel) {}
        }
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func save() {
        let year = includeBirthYear ? birthYear : nil
        if let person {
            person.name = trimmedName
            person.birthYear = year
        } else {
            modelContext.insert(Person(name: trimmedName, birthYear: year))
        }
        do {
            try modelContext.save()
            dismiss()
        } catch {
            showSaveError = true
        }
    }

    private func deletePerson() {
        guard let person else { return }
        modelContext.delete(person)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            showSaveError = true
        }
    }
}
