import Foundation
import SwiftData

enum PeopleSeeder {
    /// Inserts the default person the first time the app has nobody stored.
    @MainActor
    static func seedIfNeeded(in context: ModelContext) {
        let descriptor = FetchDescriptor<Person>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }
        context.insert(Person(name: Copy.defaultPersonName))
        do {
            try context.save()
        } catch {
            // The home screen can try again while nobody is stored.
        }
    }
}
