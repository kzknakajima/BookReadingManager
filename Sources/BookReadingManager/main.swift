import SwiftUI
import AppKit

// SwiftUI App として起動する前に「通常のフォアグラウンドアプリ」として登録する
// これをしないとウィンドウがキーウィンドウになれずキーボード入力を受け取れない
NSApplication.shared.setActivationPolicy(.regular)
BookReadingManagerApp.main()
