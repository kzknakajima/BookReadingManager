import SwiftUI

struct BookReadingManagerApp: App {
    @StateObject private var store = BookStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .frame(minWidth: 800, minHeight: 500)
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}
