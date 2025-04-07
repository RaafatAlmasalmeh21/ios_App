import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    @Published var currentLanguage: Language
    @Published var bundle = Bundle.main
    
    static let shared = LocalizationManager()
    
    init() {
        // Load saved language or use system language
        let savedLanguageCode = UserDefaults.standard.string(forKey: "UserSelectedLanguage")
        
        if let code = savedLanguageCode, let language = Language(rawValue: code) {
            self.currentLanguage = language
        } else if let languageCode = Locale.current.language.languageCode?.identifier,
                  let language = Language(rawValue: languageCode) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = .english
        }
        
        // Initialize bundle for the current language
        self.updateBundle()
    }
    
    private func updateBundle() {
        // Get the path to the resource bundle for the selected language
        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj") else {
            bundle = Bundle.main
            return
        }
        
        bundle = Bundle(path: path) ?? Bundle.main
    }
    
    func switchLanguage(to language: Language) {
        self.currentLanguage = language
        self.updateBundle()
        
        // Save selected language
        UserDefaults.standard.set(language.rawValue, forKey: "UserSelectedLanguage")
        
        // Also set AppleLanguages for system-level language change (applies on app restart)
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Force refresh notifications to any observers
        objectWillChange.send()
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
        return localizedWithBundle(LocalizationManager.shared.bundle)
    }
    
    func localizedWithBundle(_ bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// SwiftUI localization helper view
struct LocalizedText: View {
    @ObservedObject private var manager = LocalizationManager.shared
    let key: String
    let args: [CVarArg]
    
    init(_ key: String, args: CVarArg...) {
        self.key = key
        self.args = args
    }
    
    var body: some View {
        Text(key.localizedWithBundle(manager.bundle).localized(with: args))
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