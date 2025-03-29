import Foundation
import UIKit
import Vision
import CoreImage
import CoreML

class AnalysisService: ObservableObject {
    @Published var isAnalyzing = false
    @Published var result: TradingAnalysisResult?
    @Published var error: String?
    
    private let geminiService = GeminiService()
    
    // Analyze image for trading patterns
    func analyzeImage(_ image: UIImage, level: AnalysisLevel) {
        self.isAnalyzing = true
        self.error = nil
        
        // Preprocess the image to enhance chart visibility
        guard let preprocessedImage = preprocessImage(image) else {
            self.error = "Failed to preprocess image"
            self.isAnalyzing = false
            return
        }
        
        // Choose between Gemini API analysis or simulated analysis based on configuration
        #if USE_SIMULATED_ANALYSIS
        // For demo purposes, we're simulating the AI analysis process
        simulateAnalysis(preprocessedImage, level: level) { [weak self] result in
            DispatchQueue.main.async {
                self?.result = result
                self?.isAnalyzing = false
            }
        }
        #else
        // Use Gemini API for real analysis
        let analysisPrompt = generatePromptForLevel(level)
        
        Task {
            await geminiService.analyzeImage(preprocessedImage, prompt: analysisPrompt)
            
            // Process response on main thread
            await MainActor.run {
                if let error = geminiService.error {
                    self.error = error
                    self.isAnalyzing = false
                } else if let analysisText = geminiService.result {
                    // Parse the text response into our structured format
                    self.result = geminiService.parseAnalysisResponse(analysisText)
                    self.isAnalyzing = false
                } else {
                    self.error = "No analysis result received"
                    self.isAnalyzing = false
                }
            }
        }
        #endif
    }
    
    // Create prompt based on analysis level
    private func generatePromptForLevel(_ level: AnalysisLevel) -> String {
        let currentLanguage = LocalizationManager.shared.currentLanguage
        
        // Base prompts on current language
        if currentLanguage == .arabic {
            switch level {
            case .basic:
                return "قم بتوفير تحليل أساسي يركز فقط على الاتجاه العام وتوصية بسيطة."
                
            case .intermediate:
                return "قم بتوفير تحليل متوسط المستوى يشمل مستويات الدعم/المقاومة، نقاط الدخول/الخروج، والمؤشرات الفنية الأساسية."
                
            case .advanced:
                return "قم بتوفير تحليل متقدم يشمل التعرف على الأنماط، تحليل الإطارات الزمنية المتعددة، مستويات الدعم/المقاومة التفصيلية، واستراتيجية تداول شاملة."
            }
        } else {
            // English prompts (default)
            switch level {
            case .basic:
                return "Provide a basic analysis focusing just on the overall trend and a simple recommendation."
                
            case .intermediate:
                return "Provide an intermediate analysis including support/resistance levels, entry/exit points, and basic technical indicators."
                
            case .advanced:
                return "Provide an advanced analysis including pattern recognition, multiple timeframe analysis, detailed support/resistance levels, and comprehensive trading strategy."
            }
        }
    }
    
    // Preprocess image for better analysis
    private func preprocessImage(_ image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        // Apply filters to enhance charts
        let filters = CIFilter(name: "CIColorControls")
        filters?.setValue(ciImage, forKey: kCIInputImageKey)
        filters?.setValue(1.1, forKey: kCIInputContrastKey)
        filters?.setValue(0.0, forKey: kCIInputSaturationKey)
        
        guard let outputImage = filters?.outputImage else { return nil }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    // In a real app, this would be replaced with actual AI processing
    private func simulateAnalysis(_ image: UIImage, level: AnalysisLevel, completion: @escaping (TradingAnalysisResult) -> Void) {
        // Simulate processing time
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            var result = TradingAnalysisResult()
            
            // Randomize for simulation
            let randomTrend = [MarketTrend.bullish, MarketTrend.bearish, MarketTrend.sideways].randomElement() ?? .sideways
            result.trend = randomTrend
            
            switch level {
            case .basic:
                // Basic analysis with trend identification
                result.recommendation = self.generateBasicRecommendation(trend: randomTrend)
                result.confidence = Double.random(in: 0.5...0.9)
                
            case .intermediate:
                // Intermediate analysis with key levels
                result.recommendation = self.generateIntermediateRecommendation(trend: randomTrend)
                result.entryPoints = [Double.random(in: 100...150)]
                result.exitPoints = [Double.random(in: 150...200)]
                result.supportLevels = [Double.random(in: 90...100)]
                result.resistanceLevels = [Double.random(in: 200...210)]
                result.indicators = [
                    "RSI": "\(Int.random(in: 1...100))",
                    "MACD": "Bullish crossover",
                    "MA": "Above 200-day"
                ]
                result.confidence = Double.random(in: 0.6...0.95)
                
            case .advanced:
                // Advanced analysis with patterns and detailed information
                result.recommendation = self.generateAdvancedRecommendation(trend: randomTrend)
                result.entryPoints = [Double.random(in: 100...150)]
                result.exitPoints = [Double.random(in: 150...200)]
                result.supportLevels = [Double.random(in: 90...100), Double.random(in: 80...90)]
                result.resistanceLevels = [Double.random(in: 200...210), Double.random(in: 210...220)]
                result.indicators = [
                    "RSI": "\(Int.random(in: 1...100))",
                    "MACD": "Bullish crossover",
                    "MA": "Above 200-day",
                    "Bollinger Bands": "Price near upper band",
                    "Volume": "Above average"
                ]
                result.patterns = ["Double Bottom", "Golden Cross"]
                result.detailedAnalysis = "The chart shows a strong bullish momentum with a confirmed double bottom pattern. Volume is increasing on upward moves, confirming buyer interest. The golden cross of the 50-day moving average above the 200-day moving average suggests a longer-term bullish trend is establishing."
                result.confidence = Double.random(in: 0.7...0.98)
            }
            
            completion(result)
        }
    }
    
    // Generate basic recommendation
    private func generateBasicRecommendation(trend: MarketTrend) -> String {
        let currentLanguage = LocalizationManager.shared.currentLanguage
        
        if currentLanguage == .arabic {
            // Use the localization system for recommendations
            switch trend {
            case .bullish:
                return "bullish_basic".localized
            case .bearish:
                return "bearish_basic".localized
            case .sideways:
                return "sideways_basic".localized
            }
        } else {
            // English recommendations
            switch trend {
            case .bullish:
                return "bullish_basic".localized
            case .bearish:
                return "bearish_basic".localized
            case .sideways:
                return "sideways_basic".localized
            }
        }
    }
    
    // Generate intermediate recommendation
    private func generateIntermediateRecommendation(trend: MarketTrend) -> String {
        let currentLanguage = LocalizationManager.shared.currentLanguage
        
        if currentLanguage == .arabic {
            // Use the localization system for recommendations
            switch trend {
            case .bullish:
                return "bullish_intermediate".localized
            case .bearish:
                return "bearish_intermediate".localized
            case .sideways:
                return "sideways_intermediate".localized
            }
        } else {
            // English recommendations
            switch trend {
            case .bullish:
                return "bullish_intermediate".localized
            case .bearish:
                return "bearish_intermediate".localized
            case .sideways:
                return "sideways_intermediate".localized
            }
        }
    }
    
    // Generate advanced recommendation
    private func generateAdvancedRecommendation(trend: MarketTrend) -> String {
        let currentLanguage = LocalizationManager.shared.currentLanguage
        
        if currentLanguage == .arabic {
            // Use the localization system for recommendations
            switch trend {
            case .bullish:
                return "bullish_advanced".localized
            case .bearish:
                return "bearish_advanced".localized
            case .sideways:
                return "sideways_advanced".localized
            }
        } else {
            // English recommendations
            switch trend {
            case .bullish:
                return "bullish_advanced".localized
            case .bearish:
                return "bearish_advanced".localized
            case .sideways:
                return "sideways_advanced".localized
            }
        }
    }
    
    // In a production app, this would call the actual Vision API or custom ML model
    func performChartRecognition(_ image: UIImage) {
        // This would implement the actual chart recognition using Vision API
        // For example:
        /*
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            // Process extracted text for numbers, patterns, etc.
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
        */
    }
} 