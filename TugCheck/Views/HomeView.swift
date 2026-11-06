import SwiftData
import SwiftUI
import UIKit

private enum HomeRoute: Hashable {
    case people
    case about
    case history(UUID)
    case addPerson
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorSchemeContrast) private var contrast
    @Query(sort: \Person.createdAt) private var people: [Person]

    @State private var path = NavigationPath()
    @State private var showingCheck = false

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(Copy.homeExplanation)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(Copy.helperHoldsPhone)
                        .font(.body)
                        .foregroundStyle(supportingColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    LargeButton(
                        title: Copy.startATugCheck,
                        hint: people.isEmpty ? Copy.emptyPeople : Copy.helperHoldsPhone,
                        prominent: true
                    ) {
                        showingCheck = true
                    }
                    .disabled(people.isEmpty)

                    if people.isEmpty {
                        Text(Copy.emptyPeople)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        LargeButton(title: Copy.addPerson, hint: Copy.managePeopleHint) {
                            path.append(HomeRoute.addPerson)
                        }
                    } else {
                        Text(Copy.people)
                            .font(.title2)
                            .foregroundStyle(.primary)
                        ForEach(people) { person in
                            Button {
                                path.append(HomeRoute.history(person.id))
                            } label: {
                                personRow(person)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(rowLabel(person))
                            .accessibilityHint(Copy.historyHint)
                        }
                    }

                    LargeButton(title: Copy.people, hint: Copy.managePeopleHint) {
                        path.append(HomeRoute.people)
                    }
                    LargeButton(title: Copy.about, hint: Copy.aboutPurpose) {
                        path.append(HomeRoute.about)
                    }
                }
                .padding()
            }
            .navigationTitle(Copy.appName)
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .people:
                    PeopleListView()
                case .about:
                    AboutView()
                case .history(let personID):
                    HistoryView(personID: personID)
                case .addPerson:
                    PersonEditorView(person: nil)
                }
            }
            .task {
                PeopleSeeder.seedIfNeeded(in: modelContext)
            }
            .fullScreenCover(isPresented: $showingCheck) {
                CheckFlowView()
            }
        }
    }

    private func personRow(_ person: Person) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(person.name)
                .font(.title3)
                .foregroundStyle(.primary)
            if let last = person.lastResult {
                Text(verbatim: "\(ResultFormatting.listSeconds(last.seconds)) · \(last.date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.body)
                    .foregroundStyle(.primary)
            } else {
                Text(Copy.noResultsYet)
                    .font(.body)
                    .foregroundStyle(supportingColor)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary, lineWidth: contrast == .increased ? 2 : 1)
        )
    }

    private func rowLabel(_ person: Person) -> String {
        if let last = person.lastResult {
            let when = last.date.formatted(date: .abbreviated, time: .shortened)
            return "\(person.name), \(ResultFormatting.listSeconds(last.seconds)), \(when)"
        }
        return "\(person.name), \(Copy.noResultsYet)"
    }

    private var supportingColor: Color {
        contrast == .increased ? .primary : .secondary
    }
}
