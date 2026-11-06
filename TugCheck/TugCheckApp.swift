import SwiftData
import SwiftUI

@main
struct TugCheckApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [Person.self, TestResult.self])
    }
}
