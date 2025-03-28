//
//  AiTradingApp.swift
//  AiTrading
//
//  Created by Raafat Masalmeh on 27/03/2025.
//

import SwiftUI

@main
struct AiTradingApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    
    init() {
        // Setup language from saved preferences or device settings
        if let savedLanguageCode = UserDefaults.standard.string(forKey: "AppleLanguages"),
           let language = Language(rawValue: savedLanguageCode) {
            localizationManager.currentLanguage = language
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localizationManager)
                .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        }
    }
}
