import Foundation

public enum BookSortOrder: String, CaseIterable, Sendable {
    case dateAdded = "追加日"
    case title     = "タイトル"
    case author    = "著者"
    case rating    = "評価"
}

public struct BookFilter {
    public static func apply(
        _ books: [Book],
        status: ReadingStatus?,
        searchText: String,
        sortOrder: BookSortOrder
    ) -> [Book] {
        var result = books

        if let status {
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
}
