import Foundation
import Testing
@testable import BookReadingManagerCore

@Suite("Book モデル")
struct BookTests {

    @Test("タイトル・著者・状態を指定して Book を作成できる")
    func create() {
        let book = Book(title: "テスト本", author: "著者名", genre: "小説",
                        status: .unread, rating: 0, memo: "", dateAdded: Date())
        #expect(book.title == "テスト本")
        #expect(book.author == "著者名")
        #expect(book.status == .unread)
        #expect(book.rating == 0)
        #expect(book.dateStarted == nil)
        #expect(book.dateFinished == nil)
    }

    @Test("Book は Codable で正しくエンコード / デコードできる")
    func codableRoundtrip() throws {
        let date = Date(timeIntervalSince1970: 1_000_000)
        let original = Book(title: "吾輩は猫である", author: "夏目漱石", genre: "小説",
                            status: .finished, rating: 5, memo: "名作",
                            dateAdded: date, dateStarted: date, dateFinished: date)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Book.self, from: data)

        #expect(decoded.id == original.id)
        #expect(decoded.title == original.title)
        #expect(decoded.author == original.author)
        #expect(decoded.status == original.status)
        #expect(decoded.rating == original.rating)
        #expect(decoded.memo == original.memo)
        #expect(decoded.dateStarted != nil)
        #expect(decoded.dateFinished != nil)
    }

    @Test("ReadingStatus の rawValue が日本語であること")
    func readingStatusRawValues() {
        #expect(ReadingStatus.unread.rawValue   == "未読")
        #expect(ReadingStatus.reading.rawValue  == "読書中")
        #expect(ReadingStatus.finished.rawValue == "読了")
        #expect(ReadingStatus.paused.rawValue   == "中断")
    }

    @Test("ReadingStatus は 4 種類ある")
    func readingStatusCaseCount() {
        #expect(ReadingStatus.allCases.count == 4)
    }

    @Test("各 ReadingStatus に systemImage が設定されている")
    func readingStatusSystemImages() {
        for status in ReadingStatus.allCases {
            #expect(!status.systemImage.isEmpty)
        }
    }
}
