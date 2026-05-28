import Foundation

class BookStore: ObservableObject {
    @Published var books: [Book] = []

    private let saveKey = "BookReadingManager.books"

    init() { load() }

    func add(_ book: Book) {
        books.append(book)
        save()
    }

    func delete(_ book: Book) {
        books.removeAll { $0.id == book.id }
        save()
    }

    func update(_ book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index] = book
        save()
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Book].self, from: data) else { return }
        books = decoded
    }
}
