import SwiftUI

enum ExternalLinks {
    static let cdcSTEADI = URL(string: "https://www.cdc.gov/steadi/")!

    static var physiopedia: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.physio-pedia.com"
        components.path = "/Timed_Up_and_Go_Test_(TUG)"
        return components.url ?? cdcSTEADI
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(Copy.aboutPurpose)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(Copy.helperHoldsPhone)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(Copy.aboutDisclaimer)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(Copy.cutOffNote)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(Copy.aboutLocal)
                    .font(.body)
                    .foregroundStyle(.primary)

                Link(destination: ExternalLinks.cdcSTEADI) {
                    Text(Copy.cdcLink)
                        .font(.title3)
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.bordered)
                .accessibilityLabel(Copy.cdcLink)
                .accessibilityHint(Copy.opensInSafari)

                Link(destination: ExternalLinks.physiopedia) {
                    Text(Copy.physioLink)
                        .font(.title3)
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.bordered)
                .accessibilityLabel(Copy.physioLink)
                .accessibilityHint(Copy.opensInSafari)

                LargeButton(title: Copy.close, hint: nil) {
                    dismiss()
                }
            }
            .padding()
        }
        .navigationTitle(Copy.about)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}
