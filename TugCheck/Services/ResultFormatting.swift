import Foundation

struct ShareResult: Equatable {
    var date: Date
    var seconds: Double
    var usedWalkingAid: Bool
    var note: String?
    var observations: [String]
}

enum ResultFormatting {
    static func roundedSeconds(_ seconds: Double) -> Double {
        let safe = max(0, seconds)
        return (safe * 10).rounded() / 10
    }

    static func formatSeconds(_ seconds: Double) -> String {
        let rounded = roundedSeconds(seconds)
        return String(format: "%.1f", locale: Locale(identifier: "en_US_POSIX"), rounded)
    }

    static func listSeconds(_ seconds: Double) -> String {
        "\(formatSeconds(seconds)) \(Copy.seconds)"
    }

    static func walkingAidText(used: Bool) -> String {
        used ? Copy.walkingAidYes : Copy.walkingAidNo
    }

    static func firstName(from name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.split(whereSeparator: \.isWhitespace).first else {
            return trimmed
        }
        return String(first)
    }

    static func formatShareDate(_ date: Date, timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        return formatter.string(from: date)
    }

    static func shareText(
        personName: String,
        results: [ShareResult],
        timeZone: TimeZone = .current
    ) -> String {
        var lines: [String] = [
            Copy.appName,
            firstName(from: personName),
            "",
            Copy.shareIntro,
            "",
            Copy.cdcReference,
            ""
        ]

        if results.isEmpty {
            lines.append(Copy.noResultsYet)
        } else {
            for result in results {
                lines.append(resultBlock(result, timeZone: timeZone).joined(separator: "\n"))
                lines.append("")
            }
        }

        return lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
    }

    private static func resultBlock(_ result: ShareResult, timeZone: TimeZone) -> [String] {
        var lines = [
            "\(formatShareDate(result.date, timeZone: timeZone)) — \(formatSeconds(result.seconds)) \(Copy.seconds) — \(walkingAidText(used: result.usedWalkingAid))"
        ]
        if let note = result.note?.trimmingCharacters(in: .whitespacesAndNewlines), !note.isEmpty {
            lines.append("\(Copy.note): \(note)")
        }
        if !result.observations.isEmpty {
            lines.append("\(Copy.observations): \(result.observations.joined(separator: "; "))")
        }
        return lines
    }
}
