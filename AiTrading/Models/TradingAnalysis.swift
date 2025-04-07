import Foundation
import SwiftUI

enum AnalysisLevel: String, CaseIterable, Identifiable {
    case basic = "basic"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .basic:
            return "basic_description".localized
        case .intermediate:
            return "intermediate_description".localized
        case .advanced:
            return "advanced_description".localized
        }
    }
    
    var localizedRawValue: String {
        return self.rawValue.localized
    }
}

enum MarketTrend: String {
    case bullish = "bullish"
    case bearish = "bearish"
    case sideways = "sideways"
    
    var color: Color {
        switch self {
        case .bullish: return .green
        case .bearish: return .red
        case .sideways: return .yellow
        }
    }
    
    var localizedRawValue: String {
        return self.rawValue.localized
    }
}

struct TradingAnalysisResult {
    var trend: MarketTrend = .sideways
    var entryPoints: [Double] = []
    var exitPoints: [Double] = []
    var supportLevels: [Double] = []
    var resistanceLevels: [Double] = []
    var indicators: [String: String] = [:]
    var patterns: [String] = []
    var recommendation: String = ""
    var detailedAnalysis: String = ""
    var confidence: Double = 0.0
    
    var timestamp: Date = Date()
}

struct RiskCalculation {
    var entryPrice: Double = 0.0
    var stopLossPrice: Double = 0.0
    var takeProfitPrice: Double = 0.0
    var tradingCapital: Double = 0.0
    var riskPercentage: Double = 1.0
    
    var riskRewardRatio: Double {
        let risk = abs(entryPrice - stopLossPrice)
        let reward = abs(takeProfitPrice - entryPrice)
        return risk > 0 ? reward / risk : 0
    }
    
    var positionSize: Double {
        let riskAmount = tradingCapital * (riskPercentage / 100)
        let priceRisk = abs(entryPrice - stopLossPrice)
        return entryPrice > 0 && priceRisk > 0 ? riskAmount / priceRisk : 0
    }
    
    var potentialProfit: Double {
        return positionSize * abs(takeProfitPrice - entryPrice)
    }
    
    var potentialLoss: Double {
        return positionSize * abs(entryPrice - stopLossPrice)
    }
} 