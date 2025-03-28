import SwiftUI

struct LanguageSelectorView: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var showLanguageSelector = false
    
    var body: some View {
        Button(action: {
            showLanguageSelector = true
        }) {
            HStack(spacing: 5) {
                Text(localizationManager.currentLanguage.displayName)
                    .foregroundColor(.white)
                    .font(.subheadline)
                
                Image(systemName: "globe")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .padding(8)
            .background(Color.blue.opacity(0.6))
            .cornerRadius(8)
        }
        .actionSheet(isPresented: $showLanguageSelector) {
            ActionSheet(
                title: Text("Select Language"),
                buttons: Language.allCases.map { language in
                    .default(Text(language.displayName)) {
                        localizationManager.switchLanguage(to: language)
                    }
                } + [.cancel()]
            )
        }
    }
}

// Add Language allCases
extension Language: CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    static var allCases: [Language] {
        return [.english, .arabic]
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        LanguageSelectorView()
    }
} 