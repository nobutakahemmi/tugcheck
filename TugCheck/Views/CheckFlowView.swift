import SwiftData
import SwiftUI

struct CheckFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Person.createdAt) private var people: [Person]

    @State private var selectedPersonID: UUID?
    @State private var usedWalkingAid = false
    @State private var checks = [false, false, false, false]
    @State private var phase: Phase = .setup
    @State private var testRunID = 0
    @State private var addingPerson = false
    @State private var selectNewestOnDismiss = false
    @State private var personIDsBeforeAdd: Set<UUID> = []

    private enum Phase: Equatable {
        case setup
        case practice
        case test
        case result(Double)
    }

    private var selectedPerson: Person? {
        people.first { $0.id == selectedPersonID }
    }

    var body: some View {
        NavigationStack {
            Group {
                switch phase {
                case .setup:
                    SafetySetupView(
                        people: people,
                        selectedPersonID: $selectedPersonID,
                        usedWalkingAid: $usedWalkingAid,
                        checks: $checks,
                        onStart: start,
                        onClose: { dismiss() },
                        onAddPerson: beginAddPerson
                    )
                case .practice:
                    PracticeView(
                        onDone: { phase = .test },
                        onClose: { phase = .setup }
                    )
                case .test:
                    TestView(
                        onFinished: { seconds in
                            phase = .result(seconds)
                        },
                        onCancel: { phase = .setup }
                    )
                    .id(testRunID)
                case .result(let seconds):
                    if let selectedPerson {
                        ResultView(
                            person: selectedPerson,
                            seconds: seconds,
                            usedWalkingAid: usedWalkingAid,
                            onSave: { dismiss() },
                            onDiscard: { dismiss() },
                            onRetake: {
                                testRunID += 1
                                phase = .test
                            }
                        )
                    } else {
                        LargeButton(title: Copy.close, hint: nil) {
                            dismiss()
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(true)
        .onAppear(perform: selectInitialPersonIfNeeded)
        .onChange(of: people.count) { _, _ in
            selectInitialPersonIfNeeded()
        }
        .onChange(of: selectedPersonID) { _, _ in
            applyWalkingAidDefault()
        }
        .sheet(isPresented: $addingPerson, onDismiss: selectNewestPersonIfNeeded) {
            NavigationStack {
                PersonEditorView(person: nil)
            }
        }
    }

    private var title: String {
        switch phase {
        case .setup:
            Copy.safetyTitle
        case .practice:
            Copy.practiceTitle
        case .test:
            Copy.appName
        case .result:
            Copy.resultTitle
        }
    }

    private func selectInitialPersonIfNeeded() {
        if let selectedPersonID, people.contains(where: { $0.id == selectedPersonID }) {
            return
        }
        selectedPersonID = people.first?.id
        applyWalkingAidDefault()
    }

    private func applyWalkingAidDefault() {
        usedWalkingAid = selectedPerson?.lastResult?.usedWalkingAid ?? false
    }

    private func start() {
        guard let person = selectedPerson else { return }
        if person.results.isEmpty {
            phase = .practice
        } else {
            phase = .test
        }
    }

    private func beginAddPerson() {
        personIDsBeforeAdd = Set(people.map(\.id))
        selectNewestOnDismiss = true
        addingPerson = true
    }

    private func selectNewestPersonIfNeeded() {
        guard selectNewestOnDismiss else { return }
        selectNewestOnDismiss = false
        let descriptor = FetchDescriptor<Person>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        guard let newest = (try? modelContext.fetch(descriptor))?.first else { return }
        if !personIDsBeforeAdd.contains(newest.id) {
            selectedPersonID = newest.id
        }
    }
}
