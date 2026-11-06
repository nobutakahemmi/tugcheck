import XCTest
@testable import TugCheck

final class ResultFormattingTests: XCTestCase {
    func testFormatSecondsUsesOneDecimalAndADot() {
        XCTAssertEqual(ResultFormatting.formatSeconds(0), "0.0")
        XCTAssertEqual(ResultFormatting.formatSeconds(12), "12.0")
        XCTAssertEqual(ResultFormatting.formatSeconds(1.25), "1.3")
        XCTAssertEqual(ResultFormatting.formatSeconds(-2), "0.0")
        XCTAssertEqual(ResultFormatting.formatSeconds(10), "10.0")
        XCTAssertTrue(ResultFormatting.formatSeconds(8.5).contains("."))
        XCTAssertFalse(ResultFormatting.formatSeconds(8.5).contains(","))
    }

    func testListSecondsAndWalkingAid() {
        XCTAssertEqual(ResultFormatting.listSeconds(12), "12.0 seconds")
        XCTAssertEqual(ResultFormatting.walkingAidText(used: true), Copy.walkingAidYes)
        XCTAssertEqual(ResultFormatting.walkingAidText(used: false), Copy.walkingAidNo)
    }

    func testFirstName() {
        XCTAssertEqual(ResultFormatting.firstName(from: "Me"), "Me")
        XCTAssertEqual(ResultFormatting.firstName(from: "Ada Lovelace"), "Ada")
        XCTAssertEqual(ResultFormatting.firstName(from: "  Grace Hopper "), "Grace")
        XCTAssertEqual(ResultFormatting.firstName(from: "   "), "")
    }

    func testObservationOrderFollowsTheChecklist() {
        let selected: Set<String> = [
            MobilityObservation.shuffling.label,
            MobilityObservation.shortStrides.label,
            MobilityObservation.slowOrTentativePace.label
        ]
        XCTAssertEqual(
            MobilityObservation.ordered(selected),
            [
                "Slow or tentative pace",
                "Short strides",
                "Shuffling"
            ]
        )
    }

    func testShareTextIncludesRequiredDetails() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let components = DateComponents(
            calendar: calendar,
            year: 2026,
            month: 10,
            day: 19,
            hour: 15,
            minute: 56
        )
        let date = try XCTUnwrap(components.date)
        let zone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let text = ResultFormatting.shareText(
            personName: "Alex Example",
            results: [
                ShareResult(
                    date: date,
                    seconds: 11.4,
                    usedWalkingAid: true,
                    note: " Smooth turn ",
                    observations: ["Short strides", "Shuffling"]
                ),
                ShareResult(
                    date: date.addingTimeInterval(-3600),
                    seconds: 13,
                    usedWalkingAid: false,
                    note: "   ",
                    observations: []
                )
            ],
            timeZone: zone
        )

        let expected = """
        TugCheck
        Alex

        Track your mobility. Share with your doctor.

        CDC STEADI uses 12 seconds as a reference point. Cut-offs differ by group, so the trend over time matters more than one result. This is not a diagnosis. Share your results with your doctor.

        Oct 19, 2026, 3:56 PM — 11.4 seconds — Walking aid: Yes
        Note: Smooth turn
        Observations: Short strides; Shuffling

        Oct 19, 2026, 2:56 PM — 13.0 seconds — Walking aid: No
        """
        XCTAssertEqual(text, expected + "\n")
        XCTAssertTrue(text.contains(Copy.cdcReference))
        XCTAssertFalse(text.localizedCaseInsensitiveContains("fall risk"))
    }

    func testShareTextWithNoResultsStillIncludesTheReference() {
        let text = ResultFormatting.shareText(personName: "Me", results: [], timeZone: TimeZone(secondsFromGMT: 0)!)
        XCTAssertTrue(text.contains("Me"))
        XCTAssertTrue(text.contains(Copy.noResultsYet))
        XCTAssertTrue(text.contains(Copy.cdcReference))
    }
}
