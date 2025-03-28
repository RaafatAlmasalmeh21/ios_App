import SwiftUI

struct TradingCalculatorView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                        Text("Entry Price")
                        Spacer()
                        TextField("0.00", value: $entryPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Stop Loss")
                        Spacer()
                        TextField("0.00", value: $stopLossPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Take Profit")
                        Spacer()
                        TextField("0.00", value: $exitPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                } header: {
                    Text("Price Levels")
                }
                
                // Account settings
                Section {
                    HStack {
                        Text("Trading Capital")
                        Spacer()
                        TextField("10000.00", value: $tradingCapital, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Risk Percentage")
                        Spacer()
                        
                        // Stepper for risk percentage
                        Stepper("\(riskPercentage, specifier: "%.1f")%", value: $riskPercentage, in: 0.1...10.0, step: 0.1)
                    }
                } header: {
                    Text("Account Settings")
                }
                
                // Calculation results
                Section {
                    ResultRow(label: "Risk/Reward Ratio", value: String(format: "%.2f", riskCalculation.riskRewardRatio))
                    
                    ResultRow(label: "Position Size", value: String(format: "%.2f units", riskCalculation.positionSize))
                    
                    ResultRow(label: "Potential Profit", value: CalculatorService.formatCurrency(riskCalculation.potentialProfit))
                    
                    ResultRow(label: "Potential Loss", value: CalculatorService.formatCurrency(riskCalculation.potentialLoss))
                    
                    if entryPrice > 0 && exitPrice > 0 {
                        let profitPercentage = CalculatorService.calculateProfitPercentage(entryPrice: entryPrice, exitPrice: exitPrice)
                        ResultRow(
                            label: "Profit/Loss %",
                            value: CalculatorService.formatPercentage(profitPercentage),
                            valueColor: profitPercentage >= 0 ? .green : .red
                        )
                    }
                } header: {
                    Text("Calculation Results")
                }
                
                // Risk assessment
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Risk Assessment:")
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            // Simple risk assessment label
                            if riskCalculation.riskRewardRatio >= 2 {
                                Text("Good Trade")
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                            } else if riskCalculation.riskRewardRatio >= 1 {
                                Text("Average Trade")
                                    .foregroundColor(.yellow)
                                    .fontWeight(.bold)
                            } else {
                                Text("Poor Risk/Reward")
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        Text("A good trade typically has a risk/reward ratio of 1:2 or better, meaning the potential profit is at least twice the potential loss.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Trade Assessment")
                }
            }
            .navigationTitle("Trading Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ResultRow: View {
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
    }
}

#Preview {
    TradingCalculatorView(entryPrice: 100.0, exitPrice: 120.0)
} 