import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    @Published var currentLanguage: Language
    
    static let shared = LocalizationManager()
    
    init() {
        // Default to system language, fallback to English
        if let languageCode = Locale.current.language.languageCode?.identifier,
           let language = Language(rawValue: languageCode) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = .english
        }
    }
    
    func switchLanguage(to language: Language) {
        self.currentLanguage = language
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

enum Language: String {
    case english = "en"
    case arabic = "ar"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }
    
    var isRTL: Bool {
        return self == .arabic
    }
}

// SwiftUI extension for localization
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// SwiftUI localization helper view
struct LocalizedText: View {
    let key: String
    let args: [CVarArg]
    
    init(_ key: String, args: CVarArg...) {
        self.key = key
        self.args = args
    }
    
    var body: some View {
        Text(key.localized(with: args))
    }
}

// View modifier for RTL support
struct LocalizationViewModifier: ViewModifier {
    @ObservedObject var manager = LocalizationManager.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.layoutDirection, manager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}

extension View {
    func localized() -> some View {
        modifier(LocalizationViewModifier())
    }
} 