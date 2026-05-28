import Foundation

public enum ReadingStatus: String, CaseIterable, Codable, Sendable {
    case unread   = "未読"
    case reading  = "読書中"
    case finished = "読了"
    case paused   = "中断"

    public var systemImage: String {
        switch self {
        case .unread:   return "book.closed"
        case .reading:  return "book.fill"
        case .finished: return "checkmark.circle.fill"
        case .paused:   return "pause.circle.fill"
        }
    }
}

public struct Book: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var title: String
    public var author: String
    public var genre: String
    public var status: ReadingStatus
    public var rating: Int
    public var memo: String
    public var dateAdded: Date
    public var dateStarted: Date?
    public var dateFinished: Date?

    public init(
        id: UUID = UUID(),
        title: String,
        author: String,
        genre: String,
        status: ReadingStatus,
        rating: Int,
        memo: String,
        dateAdded: Date,
        dateStarted: Date? = nil,
        dateFinished: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.genre = genre
        self.status = status
        self.rating = rating
        self.memo = memo
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
    }
}
