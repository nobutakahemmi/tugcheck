import Foundation
import SwiftData

@Model
final class TestResult {
    var id: UUID
    var date: Date
    var seconds: Double
    var usedWalkingAid: Bool
    var note: String?
    var observations: [String]
    var person: Person?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        seconds: Double,
        usedWalkingAid: Bool,
        note: String? = nil,
        observations: [String] = [],
        person: Person? = nil
    ) {
        self.id = id
        self.date = date
        self.seconds = seconds
        self.usedWalkingAid = usedWalkingAid
        self.note = note
        self.observations = observations
        self.person = person
    }
}
