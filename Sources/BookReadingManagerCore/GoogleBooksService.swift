import Foundation

public struct GoogleBooksService {
    public static func fetchCoverURL(title: String, author: String) async throws -> String? {
        var parts: [String] = []
        if !title.isEmpty  { parts.append("intitle:\(title)") }
        if !author.isEmpty { parts.append("inauthor:\(author)") }
        guard !parts.isEmpty else { return nil }

        let query = parts.joined(separator: "+")
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encoded)&maxResults=5") else {
            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)

        // サムネイルが存在する最初のアイテムを使う
        guard let thumbnail = response.items?.compactMap({ $0.volumeInfo.imageLinks?.thumbnail }).first else {
            return nil
        }

        return thumbnail
            .replacingOccurrences(of: "http://", with: "https://")  // ATS 対策
            .replacingOccurrences(of: "zoom=1", with: "zoom=2")     // より大きい画像
    }
}

// MARK: - Internal response models

private struct GoogleBooksResponse: Codable {
    let items: [GoogleBooksItem]?
}

private struct GoogleBooksItem: Codable {
    let volumeInfo: VolumeInfo
}

private struct VolumeInfo: Codable {
    let imageLinks: ImageLinks?
}

private struct ImageLinks: Codable {
    let thumbnail: String?
}
