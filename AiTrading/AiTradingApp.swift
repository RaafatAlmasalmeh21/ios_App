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
        // Set initial language if not already set
        if UserDefaults.standard.object(forKey: "UserSelectedLanguage") == nil {
            if let preferredLanguage = Locale.preferredLanguages.first,
               preferredLanguage.starts(with: "ar") {
                UserDefaults.standard.set("ar", forKey: "UserSelectedLanguage")
            } else {
                UserDefaults.standard.set("en", forKey: "UserSelectedLanguage")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(localizationManager)
                .onAppear {
                    // Ensure localization settings are up-to-date
                    if let languageCode = UserDefaults.standard.string(forKey: "UserSelectedLanguage"),
                       let language = Language(rawValue: languageCode) {
                        localizationManager.switchLanguage(to: language)
                    }
                }
        }
    }
}
