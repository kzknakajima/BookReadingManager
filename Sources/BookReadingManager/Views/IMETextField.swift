import SwiftUI
import AppKit

struct IMETextField: NSViewRepresentable {
    let placeholder: String
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextField {
        let field = NSTextField()
        field.placeholderString = placeholder
        field.delegate = context.coordinator
        field.bezelStyle = .roundedBezel
        field.isBordered = false
        field.drawsBackground = false
        field.focusRingType = .none
        return field
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        // 変換中（currentEditor != nil）はSwiftUI側からの書き戻しを止める
        // これをしないとIME変換中にSwiftUIの再レンダリングが変換を中断する
        if nsView.currentEditor() == nil {
            nsView.stringValue = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let field = obj.object as? NSTextField else { return }
            text = field.stringValue
        }
    }
}
