import SwiftUI

struct TradingCalculatorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    // Default values from analysis
    @State private var entryPrice: Double
    @State private var exitPrice: Double
    
    // User input fields
    @State private var stopLossPrice: Double = 0.0
    @State private var tradingCapital: Double = 10000.0
    @State private var riskPercentage: Double = 1.0
    
    // Computed values
    private var riskCalculation: RiskCalculation {
        var calc = RiskCalculation()
        calc.entryPrice = entryPrice
        calc.stopLossPrice = stopLossPrice
        calc.takeProfitPrice = exitPrice
        calc.tradingCapital = tradingCapital
        calc.riskPercentage = riskPercentage
        return calc
    }
    
    init(entryPrice: Double = 0.0, exitPrice: Double = 0.0) {
        self._entryPrice = State(initialValue: entryPrice)
        self._exitPrice = State(initialValue: exitPrice)
        
        // Set a default stop loss based on entry
        if entryPrice > 0 {
            self._stopLossPrice = State(initialValue: entryPrice * 0.95) // 5% below entry by default
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Price inputs
                Section {
                    HStack {
                        LocalizedText("entry_price")
                        Spacer()
                        TextField("0.00", value: $entryPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        LocalizedText("stop_loss")
                        Spacer()
                        TextField("0.00", value: $stopLossPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        LocalizedText("take_profit")
                        Spacer()
                        TextField("0.00", value: $exitPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                } header: {
                    LocalizedText("price_levels")
                }
                
                // Account settings
                Section {
                    HStack {
                        LocalizedText("trading_capital")
                        Spacer()
                        TextField("10000.00", value: $tradingCapital, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        LocalizedText("risk_percentage")
                        Spacer()
                        
                        // Stepper for risk percentage
                        Stepper("\(riskPercentage, specifier: "%.1f")%", value: $riskPercentage, in: 0.1...10.0, step: 0.1)
                    }
                } header: {
                    LocalizedText("account_settings")
                }
                
                // Calculation results
                Section {
                    ResultRow(label: "risk_reward_ratio".localized, value: String(format: "%.2f", riskCalculation.riskRewardRatio))
                    
                    ResultRow(label: "position_size".localized, value: String(format: "%.2f units", riskCalculation.positionSize))
                    
                    ResultRow(label: "potential_profit".localized, value: CalculatorService.formatCurrency(riskCalculation.potentialProfit))
                    
                    ResultRow(label: "potential_loss".localized, value: CalculatorService.formatCurrency(riskCalculation.potentialLoss))
                    
                    if entryPrice > 0 && exitPrice > 0 {
                        let profitPercentage = CalculatorService.calculateProfitPercentage(entryPrice: entryPrice, exitPrice: exitPrice)
                        ResultRow(
                            label: "profit_loss_percentage".localized,
                            value: CalculatorService.formatPercentage(profitPercentage),
                            valueColor: profitPercentage >= 0 ? .green : .red
                        )
                    }
                } header: {
                    LocalizedText("calculation_results")
                }
                
                // Risk assessment
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            LocalizedText("risk_assessment")
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            // Simple risk assessment label
                            if riskCalculation.riskRewardRatio >= 2 {
                                LocalizedText("good_trade")
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                            } else if riskCalculation.riskRewardRatio >= 1 {
                                LocalizedText("average_trade")
                                    .foregroundColor(.yellow)
                                    .fontWeight(.bold)
                            } else {
                                LocalizedText("poor_risk_reward")
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        LocalizedText("good_trade_description")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    LocalizedText("trade_assessment")
                }
            }
            .navigationTitle("trading_calculator_title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) {
                        dismiss()
                    }
                }
            }
        }
        .id(localizationManager.currentLanguage.rawValue) // Force refresh when language changes
        .localized() // Apply RTL for Arabic
    }
}

struct ResultRow: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    let label: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(valueColor)
                .fontWeight(.medium)
        }
        .id("\(localizationManager.currentLanguage.rawValue)_\(label)")
    }
}

#Preview {
    TradingCalculatorView(entryPrice: 100.0, exitPrice: 120.0)
} 