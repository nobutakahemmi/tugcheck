import XCTest
@testable import TugCheck

final class CopyAuditTests: XCTestCase {
    func testRequiredSentencesMatchTheWellnessWording() {
        XCTAssertEqual(
            Copy.cdcReference,
            "CDC STEADI uses 12 seconds as a reference point. Cut-offs differ by group, so the trend over time matters more than one result. This is not a diagnosis. Share your results with your doctor."
        )
        XCTAssertEqual(
            Copy.aboutDisclaimer,
            "TugCheck is a wellness tool and does not diagnose or treat any condition. Stop the test if the person feels dizzy, pain, or short of breath, and always have someone nearby."
        )
        XCTAssertEqual(Copy.doneStartTimed, "Done — start the timed test")
        XCTAssertEqual(Copy.cdcReferenceLabel, "CDC reference")
        XCTAssertEqual(Copy.defaultPersonName, "Me")
        XCTAssertEqual(Copy.startATugCheck, "Start a TugCheck")
    }

    func testUserFacingCopyAvoidsFallRiskLanguage() {
        for text in Copy.auditedUserFacingText {
            XCTAssertNil(
                text.range(of: "fall risk", options: [.caseInsensitive]),
                text
            )
            XCTAssertNil(
                text.range(of: "\\brisk\\b", options: [.regularExpression, .caseInsensitive]),
                text
            )
            if text != Copy.aboutDisclaimer {
                XCTAssertNil(
                    text.range(of: "diagnose", options: [.caseInsensitive]),
                    text
                )
            }
            if text != Copy.cdcReference {
                XCTAssertNil(
                    text.range(of: "diagnosis", options: [.caseInsensitive]),
                    text
                )
            }
        }
    }

    func testObservationLabelsAreTheSavedValues() {
        XCTAssertEqual(MobilityObservation.allCases.count, 8)
        XCTAssertEqual(
            MobilityObservation.allCases.map(\.label),
            [
                "Slow or tentative pace",
                "Loss of balance",
                "Short strides",
                "Little or no arm swing",
                "Steadying on walls or furniture",
                "Shuffling",
                "Turning in one stiff block",
                "Not using the walking aid properly"
            ]
        )
    }
}
