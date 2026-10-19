import Charts
import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorSchemeContrast) private var contrast

    let personID: UUID

    @Query(sort: \Person.createdAt) private var people: [Person]
    @Query(sort: \TestResult.date, order: .reverse) private var allResults: [TestResult]

    private var person: Person? {
        people.first { $0.id == personID }
    }

    private var resultsNewestFirst: [TestResult] {
        allResults.filter { $0.person?.id == personID }
    }

    private var resultsOldestFirst: [TestResult] {
        resultsNewestFirst.sorted { $0.date < $1.date }
    }

    var body: some View {
        Group {
            if let person {
                historyList(for: person)
            } else {
                VStack(spacing: 16) {
                    Text(Copy.noResultsYet)
                        .font(.body)
                    LargeButton(title: Copy.close, hint: nil) {
                        dismiss()
                    }
                }
                .padding()
            }
        }
        .navigationTitle(person?.name ?? Copy.history)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    private func historyList(for person: Person) -> some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    if resultsOldestFirst.count >= 2 {
                        chart
                    } else {
                        Text(Copy.chartNeedsMore)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                    Text(Copy.cdcReference)
                        .font(.body)
                        .foregroundStyle(.primary)
                    Text(Copy.cutOffNote)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                .padding(.vertical, 8)
            }

            Section {
                if resultsNewestFirst.isEmpty {
                    Text(Copy.noResultsYet)
                        .font(.body)
                        .frame(minHeight: 60)
                } else {
                    ForEach(resultsNewestFirst) { result in
                        resultRow(result)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    delete(result)
                                } label: {
                                    Text(Copy.delete)
                                }
                                .accessibilityLabel(Copy.deleteResult)
                            }
                    }
                }
            } header: {
                Text(Copy.history)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                shareButton(for: person)
                LargeButton(title: Copy.close, hint: nil) {
                    dismiss()
                }
            }
            .padding()
            .background(.background)
        }
    }

    private var chart: some View {
        let points = resultsOldestFirst
        let domain = yDomain(for: points)
        return Chart {
            ForEach(points) { result in
                LineMark(
                    x: .value(Copy.date, result.date),
                    y: .value(Copy.seconds, result.seconds)
                )
                PointMark(
                    x: .value(Copy.date, result.date),
                    y: .value(Copy.seconds, result.seconds)
                )
            }
            RuleMark(y: .value(Copy.cdcReferenceLabel, 12.0))
                .lineStyle(StrokeStyle(lineWidth: contrast == .increased ? 3 : 2, dash: [6, 4]))
                .foregroundStyle(Color.primary)
                .annotation(position: .top, alignment: .trailing) {
                    Text(Copy.cdcReferenceLabel)
                        .font(.caption)
                        .foregroundStyle(.primary)
                }
        }
        .chartYScale(domain: domain)
        .chartLegend(.hidden)
        .frame(minHeight: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Copy.chartLabel)
        .accessibilityValue(chartSummary(points))
    }

    private func resultRow(_ result: TestResult) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(result.date.formatted(date: .abbreviated, time: .shortened))
                .font(.headline)
            Text(ResultFormatting.listSeconds(result.seconds))
                .font(.title3)
            Text(ResultFormatting.walkingAidText(used: result.usedWalkingAid))
                .font(.body)
            if let note = result.note?.trimmingCharacters(in: .whitespacesAndNewlines), !note.isEmpty {
                Text(verbatim: "\(Copy.note): \(note)")
                    .font(.body)
            }
            if !result.observations.isEmpty {
                Text(verbatim: "\(Copy.observations): \(result.observations.joined(separator: ", "))")
                    .font(.body)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityAction(named: Copy.deleteResult) {
            delete(result)
        }
    }

    @ViewBuilder
    private func shareButton(for person: Person) -> some View {
        if resultsNewestFirst.isEmpty {
            LargeButton(title: Copy.share, hint: Copy.shareNeedsResult, prominent: true) {}
                .disabled(true)
        } else {
            ShareLink(item: shareText(for: person)) {
                Text(Copy.share)
                    .font(.title3)
                    .frame(maxWidth: .infinity, minHeight: 60)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel(Copy.share)
            .accessibilityHint(Copy.shareHint)
        }
    }

    private func shareText(for person: Person) -> String {
        let payload = resultsNewestFirst.map { result in
            ShareResult(
                date: result.date,
                seconds: result.seconds,
                usedWalkingAid: result.usedWalkingAid,
                note: result.note,
                observations: result.observations
            )
        }
        return ResultFormatting.shareText(personName: person.name, results: payload)
    }

    private func delete(_ result: TestResult) {
        modelContext.delete(result)
        do {
            try modelContext.save()
        } catch {
            // The row stays if the save failed.
        }
    }

    private func yDomain(for points: [TestResult]) -> ClosedRange<Double> {
        let values = points.map(\.seconds) + [12]
        let lower = max(0, (values.min() ?? 0) - 2)
        let upper = (values.max() ?? 12) + 2
        if upper <= lower {
            return 0...14
        }
        return lower...upper
    }

    private func chartSummary(_ points: [TestResult]) -> String {
        points.map { result in
            let when = result.date.formatted(date: .abbreviated, time: .omitted)
            return "\(when), \(ResultFormatting.listSeconds(result.seconds))"
        }
        .joined(separator: ". ")
    }
}
