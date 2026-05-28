import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var store: BookStore
    @Binding var selectedStatus: ReadingStatus?

    func count(for status: ReadingStatus?) -> Int {
        guard let status else { return store.books.count }
        return store.books.filter { $0.status == status }.count
    }

    var averageRating: String {
        let rated = store.books.filter { $0.rating > 0 }
        guard !rated.isEmpty else { return "未評価" }
        let avg = Double(rated.map(\.rating).reduce(0, +)) / Double(rated.count)
        return String(format: "%.1f ★", avg)
    }

    var body: some View {
        List(selection: $selectedStatus) {
            Section("ライブラリ") {
                SidebarRow(label: "すべての本", systemImage: "books.vertical.fill",
                           color: .accentColor, count: count(for: nil))
                    .tag(ReadingStatus?.none)

                ForEach(ReadingStatus.allCases, id: \.self) { status in
                    SidebarRow(label: status.rawValue, systemImage: status.systemImage,
                               color: status.color, count: count(for: status))
                        .tag(ReadingStatus?.some(status))
                }
            }

            Section("統計") {
                StatRow(label: "読了数", value: "\(count(for: .finished))冊")
                StatRow(label: "平均評価", value: averageRating)
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 180)
    }
}

struct SidebarRow: View {
    let label: String
    let systemImage: String
    let color: Color
    let count: Int

    var body: some View {
        HStack {
            Label(label, systemImage: systemImage)
                .foregroundStyle(color)
            Spacer()
            Text("\(count)")
                .foregroundStyle(.secondary)
                .font(.caption)
                .monospacedDigit()
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}
