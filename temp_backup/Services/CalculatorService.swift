import Foundation

class CalculatorService {
    
    // Calculate risk/reward ratio
    static func calculateRiskRewardRatio(entryPrice: Double, stopLoss: Double, takeProfit: Double) -> Double {
        let risk = abs(entryPrice - stopLoss)
        let reward = abs(takeProfit - entryPrice)
        
        guard risk > 0 else { return 0 }
        return reward / risk
    }
    
    // Calculate position size based on risk percentage
    static func calculatePositionSize(capital: Double, riskPercentage: Double, entryPrice: Double, stopLoss: Double) -> Double {
        let riskAmount = capital * (riskPercentage / 100)
        let priceDifference = abs(entryPrice - stopLoss)
        
        guard priceDifference > 0 else { return 0 }
        return riskAmount / priceDifference
    }
    
    // Calculate potential profit
    static func calculatePotentialProfit(positionSize: Double, entryPrice: Double, targetPrice: Double) -> Double {
        return positionSize * abs(targetPrice - entryPrice)
    }
    
    // Calculate potential loss
    static func calculatePotentialLoss(positionSize: Double, entryPrice: Double, stopLoss: Double) -> Double {
        return positionSize * abs(entryPrice - stopLoss)
    }
    
    // Calculate profit percentage
    static func calculateProfitPercentage(entryPrice: Double, exitPrice: Double) -> Double {
        guard entryPrice > 0 else { return 0 }
        return ((exitPrice - entryPrice) / entryPrice) * 100
    }
    
    // Calculate expected value of a trade
    static func calculateExpectedValue(winRate: Double, riskRewardRatio: Double) -> Double {
        let winRate = winRate / 100
        return (winRate * riskRewardRatio) - (1 - winRate)
    }
    
    // Format currency with proper symbol and decimal places
    static func formatCurrency(_ value: Double, symbol: String = "$", decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        
        if let formattedValue = formatter.string(from: NSNumber(value: value)) {
            return "\(symbol)\(formattedValue)"
        }
        
        return "\(symbol)\(value)"
    }
    
    // Format percentage
    static func formatPercentage(_ value: Double, decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        
        if let formattedValue = formatter.string(from: NSNumber(value: value)) {
            return "\(formattedValue)%"
        }
        
        return "\(value)%"
    }
} 