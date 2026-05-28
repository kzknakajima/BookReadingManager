import SwiftUI
import BookReadingManagerCore

struct ContentView: View {
    @EnvironmentObject var store: BookStore
    @State private var selectedStatus: ReadingStatus? = nil
    @State private var selectedBookID: UUID? = nil
    @State private var searchText = ""
    @State private var sortOrder: BookSortOrder = .dateAdded
    @State private var showingAddBook = false

    var selectedBook: Book? {
        store.books.first { $0.id == selectedBookID }
    }

    var filteredBooks: [Book] {
        BookFilter.apply(store.books, status: selectedStatus, searchText: searchText, sortOrder: sortOrder)
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
