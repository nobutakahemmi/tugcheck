import SwiftData
import SwiftUI

struct PeopleListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Person.createdAt) private var people: [Person]

    @State private var pendingDeleteID: UUID?

    var body: some View {
        List {
            Section {
                Text(Copy.storedLocally)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            Section {
                ForEach(people) { person in
                    NavigationLink {
                        PersonEditorView(person: person)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(person.name)
                                .font(.title3)
                            if let year = person.birthYear {
                                Text(verbatim: "\(Copy.birthYear): \(String(year))")
                                    .font(.body)
                            }
                        }
                        .frame(minHeight: 60)
                    }
                    .accessibilityLabel(label(for: person))
                    .accessibilityHint(Copy.editPerson)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            pendingDeleteID = person.id
                        } label: {
                            Text(Copy.delete)
                        }
                        .accessibilityLabel(Copy.deletePersonTitle)
                    }
                }
            }
        }
        .navigationTitle(Copy.people)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                NavigationLink {
                    PersonEditorView(person: nil)
                } label: {
                    Text(Copy.addPerson)
                        .font(.title3)
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel(Copy.addPerson)
                .accessibilityHint(Copy.managePeopleHint)

                LargeButton(title: Copy.close, hint: nil) {
                    dismiss()
                }
            }
            .padding()
            .background(.background)
        }
        .confirmationDialog(
            Copy.deletePersonTitle,
            isPresented: deleteIsPresented,
            titleVisibility: .visible
        ) {
            Button(Copy.delete, role: .destructive) {
                deletePending()
            }
            Button(Copy.cancel, role: .cancel) {
                pendingDeleteID = nil
            }
        } message: {
            Text(Copy.deletePersonMessage)
        }
    }

    private var deleteIsPresented: Binding<Bool> {
        Binding(
            get: { pendingDeleteID != nil },
            set: { isPresented in
                if !isPresented {
                    pendingDeleteID = nil
                }
            }
        )
    }

    private func label(for person: Person) -> String {
        if let year = person.birthYear {
            return "\(person.name), \(Copy.birthYear) \(String(year))"
        }
        return person.name
    }

    private func deletePending() {
        guard let pendingDeleteID else { return }
        if let person = people.first(where: { $0.id == pendingDeleteID }) {
            modelContext.delete(person)
            do {
                try modelContext.save()
            } catch {
                // Leave the confirmation closed; the person remains if the save failed.
            }
        }
        self.pendingDeleteID = nil
    }
}
