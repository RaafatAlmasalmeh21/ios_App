import Foundation
import UIKit
import GoogleGenerativeAI

class GeminiService: ObservableObject {
    @Published var isAnalyzing = false
    @Published var result: String?
    @Published var error: String?
    
    // API key from Google AI Studio
    private let apiKey = "AIzaSyDZj0wJMV7hAQ_tER1RoMvVy_UCcuZOZxI"
    private let modelName = "gemini-2.0-flash-exp"
    
    private var model: GenerativeModel?
    
    init() {
        self.model = GenerativeModel(name: modelName, apiKey: apiKey)
    }
    
    func analyzeImage(_ image: UIImage, prompt: String) async {
        DispatchQueue.main.async {
            self.isAnalyzing = true
            self.error = nil
            self.result = nil
        }
        
        do {
            // Create a prompt for the image analysis
            let fullPrompt = "Analyze this trading chart image and provide: \n" +
                             "1. The market trend (bullish, bearish, or sideways)\n" +
                             "2. Key support and resistance levels\n" +
                             "3. Important technical patterns visible\n" +
                             "4. Trading recommendation\n" +
                             "\(prompt)"
            
            // Call the Gemini API with the image
            let response = try await model?.generateContent(fullPrompt, image)
            
            DispatchQueue.main.async {
                self.result = response?.text
                self.isAnalyzing = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "Error analyzing image: \(error.localizedDescription)"
                self.isAnalyzing = false
            }
        }
    }
    
    // Parse the response into a structured format if needed
    func parseAnalysisResponse(_ responseText: String) -> TradingAnalysisResult {
        var result = TradingAnalysisResult()
        
        // Default to sideways trend if no clear indication
        result.trend = .sideways
        
        // Look for trend indicators in the response
        if responseText.lowercased().contains("bullish") {
            result.trend = .bullish
        } else if responseText.lowercased().contains("bearish") {
            result.trend = .bearish
        }
        
        // Extract the recommendation (simplified approach)
        if let recommendationRange = responseText.range(of: "Trading recommendation:", options: .caseInsensitive) {
            let startIndex = recommendationRange.upperBound
            if let endIndex = responseText[startIndex...].firstIndex(of: "\n") {
                result.recommendation = String(responseText[startIndex..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                result.recommendation = String(responseText[startIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        // Set detailed analysis to the full response
        result.detailedAnalysis = responseText
        
        // Set confidence
        // A real implementation would extract this from the response
        result.confidence = 0.85
        
        return result
    }
} 