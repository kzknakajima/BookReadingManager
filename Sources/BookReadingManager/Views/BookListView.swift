import SwiftUI
import BookReadingManagerCore

struct BookListView: View {
    @EnvironmentObject var store: BookStore
    let books: [Book]
    @Binding var selectedBookID: UUID?
    @Binding var searchText: String
    @Binding var sortOrder: BookSortOrder

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("タイトル・著者・ジャンルで検索", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
            .padding(.top, 8)

            HStack {
                Picker("並び替え", selection: $sortOrder) {
                    ForEach(BookSortOrder.allCases, id: \.self) { o in
                        Text(o.rawValue).tag(o)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .font(.caption)
                Spacer()
                Text("\(books.count)冊")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 4)

            Divider()

            if books.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 32))
                        .foregroundStyle(.tertiary)
                    Text(searchText.isEmpty ? "本を追加してください" : "検索結果なし")
                        .foregroundStyle(.secondary)
                }
                Spacer()
            } else {
                List(selection: $selectedBookID) {
                    ForEach(books) { book in
                        BookRowView(book: book)
                            .tag(book.id)
                            .contextMenu {
                                Button(role: .destructive) {
                                    if selectedBookID == book.id { selectedBookID = nil }
                                    store.delete(book)
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(minWidth: 250)
    }
}

struct BookRowView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(book.title)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Spacer()
                Image(systemName: book.status.systemImage)
                    .foregroundStyle(book.status.color)
                    .font(.caption)
            }
            Text(book.author.isEmpty ? "著者不明" : book.author)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            HStack(spacing: 4) {
                if !book.genre.isEmpty {
                    Text(book.genre)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.quaternary, in: Capsule())
                }
                if book.rating > 0 {
                    Spacer()
                    HStack(spacing: 1) {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: i <= book.rating ? "star.fill" : "star")
                                .font(.system(size: 8))
                                .foregroundStyle(i <= book.rating ? .yellow : .secondary)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }
}
