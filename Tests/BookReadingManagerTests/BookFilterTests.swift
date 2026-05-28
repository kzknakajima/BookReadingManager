import Foundation
import Testing
@testable import BookReadingManagerCore

@Suite("BookFilter")
struct BookFilterTests {

    // 固定の時刻で順序が安定するようにする
    let t0 = Date(timeIntervalSince1970: 1000)
    let t1 = Date(timeIntervalSince1970: 2000)
    let t2 = Date(timeIntervalSince1970: 3000)

    var books: [Book] {
        [
            Book(title: "吾輩は猫である", author: "夏目漱石", genre: "小説",
                 status: .finished, rating: 5, memo: "名作", dateAdded: t2),
            Book(title: "坊っちゃん",    author: "夏目漱石", genre: "小説",
                 status: .reading,  rating: 4, memo: "",   dateAdded: t1),
            Book(title: "人間失格",      author: "太宰治",   genre: "小説",
                 status: .unread,   rating: 0, memo: "",   dateAdded: t0),
        ]
    }

    // MARK: - フィルタリング

    @Test("フィルターなしで全件返す")
    func noFilter() {
        let result = BookFilter.apply(books, status: nil, searchText: "", sortOrder: .title)
        #expect(result.count == 3)
    }

    @Test("ステータスでフィルタリングできる")
    func filterByStatus() {
        let result = BookFilter.apply(books, status: .finished, searchText: "", sortOrder: .title)
        #expect(result.count == 1)
        #expect(result.first?.title == "吾輩は猫である")
    }

    @Test("一致しないステータスは空を返す")
    func filterByStatusNoMatch() {
        let result = BookFilter.apply(books, status: .paused, searchText: "", sortOrder: .title)
        #expect(result.isEmpty)
    }

    // MARK: - 検索

    @Test("タイトルで検索できる")
    func searchByTitle() {
        let result = BookFilter.apply(books, status: nil, searchText: "坊", sortOrder: .title)
        #expect(result.count == 1)
        #expect(result.first?.title == "坊っちゃん")
    }

    @Test("著者で検索できる")
    func searchByAuthor() {
        let result = BookFilter.apply(books, status: nil, searchText: "夏目", sortOrder: .title)
        #expect(result.count == 2)
    }

    @Test("メモで検索できる")
    func searchByMemo() {
        let result = BookFilter.apply(books, status: nil, searchText: "名作", sortOrder: .title)
        #expect(result.count == 1)
        #expect(result.first?.title == "吾輩は猫である")
    }

    @Test("大文字小文字を区別せず検索できる")
    func caseInsensitiveSearch() {
        let testBooks = [Book(title: "Hello World", author: "Author", genre: "Test",
                              status: .unread, rating: 0, memo: "", dateAdded: Date())]
        let result = BookFilter.apply(testBooks, status: nil, searchText: "hello", sortOrder: .title)
        #expect(result.count == 1)
    }

    @Test("存在しない文字列の検索結果は空")
    func emptySearchResult() {
        let result = BookFilter.apply(books, status: nil, searchText: "存在しない本", sortOrder: .title)
        #expect(result.isEmpty)
    }

    @Test("ステータスフィルターと検索を同時に適用できる")
    func filterAndSearch() {
        let result = BookFilter.apply(books, status: .finished, searchText: "夏目", sortOrder: .title)
        #expect(result.count == 1)
        #expect(result.first?.title == "吾輩は猫である")
    }

    // MARK: - ソート

    @Test("評価の高い順にソートできる")
    func sortByRating() {
        let result = BookFilter.apply(books, status: nil, searchText: "", sortOrder: .rating)
        for i in 0..<(result.count - 1) {
            #expect(result[i].rating >= result[i + 1].rating)
        }
    }

    @Test("タイトルのあいうえお順にソートできる")
    func sortByTitle() {
        let result = BookFilter.apply(books, status: nil, searchText: "", sortOrder: .title)
        let titles = result.map(\.title)
        #expect(titles == titles.sorted())
    }

    @Test("追加日の新しい順にソートできる")
    func sortByDateAdded() {
        let result = BookFilter.apply(books, status: nil, searchText: "", sortOrder: .dateAdded)
        for i in 0..<(result.count - 1) {
            #expect(result[i].dateAdded >= result[i + 1].dateAdded)
        }
    }

    @Test("著者のあいうえお順にソートできる")
    func sortByAuthor() {
        let result = BookFilter.apply(books, status: nil, searchText: "", sortOrder: .author)
        let authors = result.map(\.author)
        #expect(authors == authors.sorted())
    }
}
