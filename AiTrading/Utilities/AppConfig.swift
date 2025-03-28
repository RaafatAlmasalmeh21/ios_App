import Foundation

// MARK: - Feature Flags
// To enable or disable features in different build configurations

// Set to true to use simulated chart analysis instead of Gemini API
#if DEBUG
let USE_SIMULATED_ANALYSIS = false
#else
let USE_SIMULATED_ANALYSIS = false
#endif

// Also enable Gemini API usage in DEBUG mode
// MARK: - App Configuration
struct AppConfig {
    static let appName = "AI Trading Assistant"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    // API Configuration
    struct API {
        static let baseURL = "https://api.example.com"
        static let timeout: TimeInterval = 30
        
        // For Gemini API
        #if DEBUG
        static let useGeminiAPI = true
        #else
        static let useGeminiAPI = true
        #endif
    }
    
    // Analytics Configuration
    struct Analytics {
        static let isEnabled = true
        static let logLevel = LogLevel.info
    }
    
    // Cache Configuration
    struct Cache {
        static let maxAgeInHours: Int = 24
        static let maxSizeInMB: Int = 50
    }
}

// MARK: - Log Levels
enum LogLevel: Int {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case none = 99
} 