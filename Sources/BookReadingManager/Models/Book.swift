import Foundation
import SwiftUI

enum ReadingStatus: String, CaseIterable, Codable {
    case unread   = "未読"
    case reading  = "読書中"
    case finished = "読了"
    case paused   = "中断"

    var systemImage: String {
        switch self {
        case .unread:   return "book.closed"
        case .reading:  return "book.fill"
        case .finished: return "checkmark.circle.fill"
        case .paused:   return "pause.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .unread:   return .gray
        case .reading:  return .blue
        case .finished: return .green
        case .paused:   return .orange
        }
    }
}

struct Book: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var author: String
    var genre: String
    var status: ReadingStatus
    var rating: Int
    var memo: String
    var dateAdded: Date
    var dateStarted: Date?
    var dateFinished: Date?
}
