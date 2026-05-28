import SwiftUI
import BookReadingManagerCore

struct BookDetailView: View {
    @EnvironmentObject var store: BookStore
    let book: Book
    let onDelete: () -> Void
    @State private var showingEdit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        if !book.author.isEmpty {
                            Text(book.author)
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Button { showingEdit = true } label: {
                        Label("編集", systemImage: "pencil")
                    }
                    .buttonStyle(.bordered)
                }

                // Badges
                HStack(spacing: 8) {
                    Label(book.status.rawValue, systemImage: book.status.systemImage)
                        .font(.subheadline)
                        .foregroundStyle(book.status.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(book.status.color.opacity(0.1), in: Capsule())

                    if !book.genre.isEmpty {
                        Text(book.genre)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.quaternary, in: Capsule())
                    }
                }

                Divider()

                // Rating
                VStack(alignment: .leading, spacing: 8) {
                    Text("評価")
                        .font(.headline)
                    if book.rating > 0 {
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: i <= book.rating ? "star.fill" : "star")
                                    .foregroundStyle(i <= book.rating ? .yellow : .secondary)
                                    .font(.title3)
                            }
                            Text("(\(book.rating)/5)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("未評価")
                            .foregroundStyle(.secondary)
                    }
                }

                // Dates
                VStack(alignment: .leading, spacing: 8) {
                    Text("日付")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 6) {
                        DateInfoRow(label: "追加日", date: book.dateAdded)
                        if let d = book.dateStarted  { DateInfoRow(label: "開始日", date: d) }
                        if let d = book.dateFinished { DateInfoRow(label: "読了日", date: d) }
                    }
                }

                // Memo
                if !book.memo.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("メモ")
                            .font(.headline)
                        Text(book.memo)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                    }
                }

                Spacer(minLength: 20)

                Button(role: .destructive) {
                    store.delete(book)
                    onDelete()
                } label: {
                    Label("この本を削除", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .sheet(isPresented: $showingEdit) {
            AddEditBookView(mode: .edit(book))
        }
    }
}

struct DateInfoRow: View {
    let label: String
    let date: Date

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 54, alignment: .leading)
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline)
        }
    }
}
