import Foundation

/// Optional helper notes saved with a result. Labels are the stored values.
enum MobilityObservation: String, CaseIterable, Identifiable {
    case slowOrTentativePace = "Slow or tentative pace"
    case lossOfBalance = "Loss of balance"
    case shortStrides = "Short strides"
    case littleOrNoArmSwing = "Little or no arm swing"
    case steadyingOnWallsOrFurniture = "Steadying on walls or furniture"
    case shuffling = "Shuffling"
    case turningInOneStiffBlock = "Turning in one stiff block"
    case notUsingWalkingAidProperly = "Not using the walking aid properly"

    var id: String { rawValue }
    var label: String { rawValue }

    /// Keeps saved observations in a stable order.
    static func ordered(_ selected: Set<String>) -> [String] {
        allCases.map(\.label).filter { selected.contains($0) }
    }
}
