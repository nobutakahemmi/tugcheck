import Foundation
import SwiftData

@Model
final class Person {
    var id: UUID
    var name: String
    var birthYear: Int?
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \TestResult.person)
    var results: [TestResult]

    init(
        id: UUID = UUID(),
        name: String,
        birthYear: Int? = nil,
        createdAt: Date = Date(),
        results: [TestResult] = []
    ) {
        self.id = id
        self.name = name
        self.birthYear = birthYear
        self.createdAt = createdAt
        self.results = results
    }

    var lastResult: TestResult? {
        results.max { $0.date < $1.date }
    }

    var resultsNewestFirst: [TestResult] {
        results.sorted { $0.date > $1.date }
    }

    var resultsOldestFirst: [TestResult] {
        results.sorted { $0.date < $1.date }
    }
}
