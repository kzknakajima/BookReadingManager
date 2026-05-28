import SwiftUI
import BookReadingManagerCore

extension ReadingStatus {
    var color: Color {
        switch self {
        case .unread:   return .gray
        case .reading:  return .blue
        case .finished: return .green
        case .paused:   return .orange
        }
    }
}
