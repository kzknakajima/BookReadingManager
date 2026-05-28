import SwiftUI

enum BookFormMode {
    case add
    case edit(Book)

    var title: String {
        switch self {
        case .add:  return "本を追加"
        case .edit: return "本を編集"
        }
    }

    var actionLabel: String {
        switch self {
        case .add:  return "追加"
        case .edit: return "保存"
        }
    }
}

struct AddEditBookView: View {
    @EnvironmentObject var store: BookStore
    @Environment(\.dismiss) var dismiss

    let mode: BookFormMode

    @State private var title: String
    @State private var author: String
    @State private var genre: String
    @State private var status: ReadingStatus
    @State private var rating: Int
    @State private var memo: String
    @State private var dateStarted: Date
    @State private var dateFinished: Date
    @State private var showStartDate: Bool
    @State private var showFinishDate: Bool

    init(mode: BookFormMode) {
        self.mode = mode
        switch mode {
        case .add:
            _title          = State(initialValue: "")
            _author         = State(initialValue: "")
            _genre          = State(initialValue: "")
            _status         = State(initialValue: .unread)
            _rating         = State(initialValue: 0)
            _memo           = State(initialValue: "")
            _dateStarted    = State(initialValue: Date())
            _dateFinished   = State(initialValue: Date())
            _showStartDate  = State(initialValue: false)
            _showFinishDate = State(initialValue: false)
        case .edit(let book):
            _title          = State(initialValue: book.title)
            _author         = State(initialValue: book.author)
            _genre          = State(initialValue: book.genre)
            _status         = State(initialValue: book.status)
            _rating         = State(initialValue: book.rating)
            _memo           = State(initialValue: book.memo)
            _dateStarted    = State(initialValue: book.dateStarted ?? Date())
            _dateFinished   = State(initialValue: book.dateFinished ?? Date())
            _showStartDate  = State(initialValue: book.dateStarted != nil)
            _showFinishDate = State(initialValue: book.dateFinished != nil)
        }
    }

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("キャンセル") { dismiss() }
                Spacer()
                Text(mode.title)
                    .fontWeight(.semibold)
                Spacer()
                Button(mode.actionLabel, action: save)
                    .buttonStyle(.borderedProminent)
                    .disabled(!isValid)
            }
            .padding()

            Divider()

            Form {
                Section("基本情報") {
                    TextField("タイトル（必須）", text: $title)
                    TextField("著者", text: $author)
                    TextField("ジャンル", text: $genre)
                }

                Section("読書状態") {
                    Picker("状態", selection: $status) {
                        ForEach(ReadingStatus.allCases, id: \.self) { s in
                            Label(s.rawValue, systemImage: s.systemImage).tag(s)
                        }
                    }
                    Toggle("開始日を記録", isOn: $showStartDate)
                    if showStartDate {
                        DatePicker("開始日", selection: $dateStarted, displayedComponents: .date)
                    }
                    Toggle("読了日を記録", isOn: $showFinishDate)
                    if showFinishDate {
                        DatePicker("読了日", selection: $dateFinished, displayedComponents: .date)
                    }
                }

                Section("評価") {
                    HStack {
                        Text("評価")
                        Spacer()
                        StarRatingView(rating: $rating)
                    }
                }

                Section("メモ") {
                    TextEditor(text: $memo)
                        .frame(minHeight: 80)
                }
            }
            .formStyle(.grouped)
        }
        .frame(width: 480, height: 560)
    }

    private func save() {
        switch mode {
        case .add:
            store.add(Book(
                title:        title.trimmingCharacters(in: .whitespaces),
                author:       author.trimmingCharacters(in: .whitespaces),
                genre:        genre.trimmingCharacters(in: .whitespaces),
                status:       status,
                rating:       rating,
                memo:         memo,
                dateAdded:    Date(),
                dateStarted:  showStartDate ? dateStarted : nil,
                dateFinished: showFinishDate ? dateFinished : nil
            ))
        case .edit(let original):
            var updated = original
            updated.title        = title.trimmingCharacters(in: .whitespaces)
            updated.author       = author.trimmingCharacters(in: .whitespaces)
            updated.genre        = genre.trimmingCharacters(in: .whitespaces)
            updated.status       = status
            updated.rating       = rating
            updated.memo         = memo
            updated.dateStarted  = showStartDate ? dateStarted : nil
            updated.dateFinished = showFinishDate ? dateFinished : nil
            store.update(updated)
        }
        dismiss()
    }
}
