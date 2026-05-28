import SwiftUI

enum SortOrder: String, CaseIterable {
    case dateAdded = "追加日"
    case title     = "タイトル"
    case author    = "著者"
    case rating    = "評価"
}

struct ContentView: View {
    @EnvironmentObject var store: BookStore
    @State private var selectedStatus: ReadingStatus? = nil
    @State private var selectedBookID: UUID? = nil
    @State private var searchText = ""
    @State private var sortOrder: SortOrder = .dateAdded
    @State private var showingAddBook = false

    var selectedBook: Book? {
        store.books.first { $0.id == selectedBookID }
    }

    var filteredBooks: [Book] {
        var result = store.books

        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText) ||
                $0.genre.localizedCaseInsensitiveContains(searchText) ||
                $0.memo.localizedCaseInsensitiveContains(searchText)
            }
        }

        switch sortOrder {
        case .dateAdded: result.sort { $0.dateAdded > $1.dateAdded }
        case .title:     result.sort { $0.title < $1.title }
        case .author:    result.sort { $0.author < $1.author }
        case .rating:    result.sort { $0.rating > $1.rating }
        }

        return result
    }

    var body: some View {
        NavigationSplitView {
            SidebarView(selectedStatus: $selectedStatus)
        } content: {
            BookListView(
                books: filteredBooks,
                selectedBookID: $selectedBookID,
                searchText: $searchText,
                sortOrder: $sortOrder
            )
            .navigationTitle(selectedStatus?.rawValue ?? "すべての本")
        } detail: {
            if let book = selectedBook {
                BookDetailView(book: book) {
                    selectedBookID = nil
                }
            } else {
                EmptyDetailView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showingAddBook = true } label: {
                    Image(systemName: "plus")
                }
                .help("本を追加")
            }
        }
        .sheet(isPresented: $showingAddBook) {
            AddEditBookView(mode: .add)
        }
        .onChange(of: store.books) { _, newBooks in
            if let id = selectedBookID, !newBooks.contains(where: { $0.id == id }) {
                selectedBookID = nil
            }
        }
    }
}

struct EmptyDetailView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical")
                .font(.system(size: 52))
                .foregroundStyle(.tertiary)
            Text("本を選択してください")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text("リストから本を選ぶか、「+」ボタンで追加しましょう")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
    }
}
