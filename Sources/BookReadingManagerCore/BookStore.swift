import Foundation

@MainActor
public class BookStore: ObservableObject {
    @Published public var books: [Book] = []

    private let defaults: UserDefaults
    private let saveKey = "BookReadingManager.books"

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    public func add(_ book: Book) {
        books.append(book)
        save()
    }

    public func delete(_ book: Book) {
        books.removeAll { $0.id == book.id }
        save()
    }

    public func update(_ book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index] = book
        save()
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(books) {
            defaults.set(encoded, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = defaults.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Book].self, from: data) else { return }
        books = decoded
    }
}
