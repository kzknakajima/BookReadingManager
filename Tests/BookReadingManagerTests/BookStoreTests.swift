import Foundation
import Testing
@testable import BookReadingManagerCore

@Suite("BookStore")
@MainActor
struct BookStoreTests {

    // 各テストが独立した UserDefaults を使うようにテストごとに新インスタンスを生成する
    func makeStore() -> BookStore {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        return BookStore(defaults: defaults)
    }

    func makeBook(title: String = "テスト本", status: ReadingStatus = .unread, rating: Int = 0) -> Book {
        Book(title: title, author: "著者", genre: "テスト",
             status: status, rating: rating, memo: "", dateAdded: Date())
    }

    // MARK: - 追加

    @Test("本を追加できる")
    func addBook() {
        let store = makeStore()
        store.add(makeBook(title: "追加テスト"))
        #expect(store.books.count == 1)
        #expect(store.books.first?.title == "追加テスト")
    }

    @Test("複数の本を追加できる")
    func addMultipleBooks() {
        let store = makeStore()
        store.add(makeBook(title: "1冊目"))
        store.add(makeBook(title: "2冊目"))
        store.add(makeBook(title: "3冊目"))
        #expect(store.books.count == 3)
    }

    // MARK: - 削除

    @Test("本を削除できる")
    func deleteBook() {
        let store = makeStore()
        let book = makeBook(title: "削除テスト")
        store.add(book)
        store.delete(book)
        #expect(store.books.isEmpty)
    }

    @Test("特定の本だけを削除できる")
    func deleteSpecificBook() {
        let store = makeStore()
        let keep   = makeBook(title: "残す本")
        let remove = makeBook(title: "削除する本")
        store.add(keep)
        store.add(remove)
        store.delete(remove)
        #expect(store.books.count == 1)
        #expect(store.books.first?.title == "残す本")
    }

    @Test("存在しない本を削除しても何も起きない")
    func deleteNonExistent() {
        let store = makeStore()
        store.delete(makeBook())
        #expect(store.books.isEmpty)
    }

    // MARK: - 更新

    @Test("本のタイトルを更新できる")
    func updateTitle() {
        let store = makeStore()
        var book = makeBook(title: "更新前")
        store.add(book)
        book.title = "更新後"
        store.update(book)
        #expect(store.books.first?.title == "更新後")
    }

    @Test("本の評価を更新できる")
    func updateRating() {
        let store = makeStore()
        var book = makeBook(rating: 2)
        store.add(book)
        book.rating = 5
        store.update(book)
        #expect(store.books.first?.rating == 5)
    }

    @Test("存在しない本の更新は何も起きない")
    func updateNonExistent() {
        let store = makeStore()
        store.update(makeBook(title: "存在しない"))
        #expect(store.books.isEmpty)
    }

    // MARK: - 永続化

    @Test("データが UserDefaults に永続化される")
    func persistence() {
        let suiteName = UUID().uuidString
        let defaults  = UserDefaults(suiteName: suiteName)!

        let store1 = BookStore(defaults: defaults)
        store1.add(makeBook(title: "永続化テスト"))

        // 同じ UserDefaults から別インスタンスを生成して読み込みを検証
        let store2 = BookStore(defaults: defaults)
        #expect(store2.books.count == 1)
        #expect(store2.books.first?.title == "永続化テスト")
    }

    @Test("削除後は次回起動時にも反映される")
    func persistenceAfterDelete() {
        let suiteName = UUID().uuidString
        let defaults  = UserDefaults(suiteName: suiteName)!

        let store1 = BookStore(defaults: defaults)
        let book = makeBook(title: "削除される本")
        store1.add(book)
        store1.delete(book)

        let store2 = BookStore(defaults: defaults)
        #expect(store2.books.isEmpty)
    }
}
