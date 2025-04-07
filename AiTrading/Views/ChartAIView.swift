import SwiftUI

struct ChartAIView: View {
    let image: UIImage
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    // Analysis state
    @State private var isAnalysisExpanded = true
    @State private var selectedAnalysisSection = 1
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Chart image
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.secondarySystemBackground))
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .padding(8)
                }
                .frame(height: 300)
                .padding(.horizontal)
                
                // Key Insights
                VStack(spacing: 16) {
                    LocalizedText("key_insights")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack(spacing: 30) {
                        // Trend
                        VStack(spacing: 10) {
                            LocalizedText("trend")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 18, weight: .bold))
                                
                                LocalizedText("range")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Volatility
                        VStack(spacing: 10) {
                            LocalizedText("volatility")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Image(systemName: "chart.bar.xaxis")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 18, weight: .bold))
                                
                                LocalizedText("high")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    HStack(spacing: 30) {
                        // Volume
                        VStack(spacing: 8) {
                            LocalizedText("volume")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            VStack(spacing: 4) {
                                LocalizedText("medium")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 4)
                                    .cornerRadius(2)
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(width: 100 * 0.5, height: 4)
                                            .cornerRadius(2),
                                        alignment: .leading
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Market Sentiment
                        VStack(spacing: 8) {
                            LocalizedText("market_sentiment")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            VStack(spacing: 4) {
                                LocalizedText("neutral")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 4)
                                    .cornerRadius(2)
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(width: 100 * 0.5, height: 4)
                                            .cornerRadius(2),
                                        alignment: .leading
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
                
                // Game Plan
                VStack(spacing: 16) {
                    LocalizedText("game_plan")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Given the market's current state with Bitcoin consolidating around the 80,000-90,000 range after experiencing volatility and price rejection, a range-bound strategy is more suitable. I recommend setting up trades near the support level at 80,000 for potential bounces with a stop-loss slightly below this area, around 78,000. Entries can be considered when the price nears support and shows signs of reversal or increase in buying volume. Conversely, selling short can be considered near the upper boundary around 90,000 with a stop-loss above 92,000. Look for confirmations from volume spikes and candlestick reversal patterns.")
                        .lineSpacing(6)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
                
                // Detailed Analysis
                VStack(spacing: 0) {
                    LocalizedText("detailed_analysis")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 16)
                    
                    // Section 1
                    AnalysisSectionView(
                        number: 1,
                        title: "Price Action and Consolidation",
                        isExpanded: selectedAnalysisSection == 1,
                        content: "The price has recently moved sharply lower from its peak around 110,000 to below 90,000, suggesting an initial bearish trend. However, the price has settled into a tight range between 80,000 and 90,000, showing signs of consolidation, which characterizes a range-bound market condition. This typical behavior suggests indecision and potential for price reversals at boundaries.",
                        onTap: {
                            withAnimation {
                                selectedAnalysisSection = selectedAnalysisSection == 1 ? 0 : 1
                            }
                        }
                    )
                    
                    Divider()
                    
                    // Section 2
                    AnalysisSectionView(
                        number: 2,
                        title: "Volume Analysis",
                        isExpanded: selectedAnalysisSection == 2,
                        content: "",
                        onTap: {
                            withAnimation {
                                selectedAnalysisSection = selectedAnalysisSection == 2 ? 0 : 2
                            }
                        }
                    )
                    
                    Divider()
                    
                    // Section 3
                    AnalysisSectionView(
                        number: 3,
                        title: "Candlestick Patterns & Price Rejections",
                        isExpanded: selectedAnalysisSection == 3,
                        content: "",
                        onTap: {
                            withAnimation {
                                selectedAnalysisSection = selectedAnalysisSection == 3 ? 0 : 3
                            }
                        }
                    )
                    
                    Divider()
                    
                    // Section 4
                    AnalysisSectionView(
                        number: 4,
                        title: "Potential Support and Resistance Zones",
                        isExpanded: selectedAnalysisSection == 4,
                        content: "",
                        onTap: {
                            withAnimation {
                                selectedAnalysisSection = selectedAnalysisSection == 4 ? 0 : 4
                            }
                        }
                    )
                    
                    Divider()
                    
                    // Section 5
                    AnalysisSectionView(
                        number: 5,
                        title: "Market Sentiment and Oscillator Insights",
                        isExpanded: selectedAnalysisSection == 5,
                        content: "",
                        onTap: {
                            withAnimation {
                                selectedAnalysisSection = selectedAnalysisSection == 5 ? 0 : 5
                            }
                        }
                    )
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
                
                // Disclaimer
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                    
                    LocalizedText("not_financial_advice")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
            }
            .padding(.vertical)
        }
        .navigationBarTitle("Chart AI", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
                .imageScale(.large)
        })
        .background(Color(UIColor.systemBackground))
        .localized() // Apply RTL layout for Arabic
        .id(localizationManager.currentLanguage.rawValue) // Force view refresh when language changes
    }
}

struct AnalysisSectionView: View {
    let number: Int
    let title: String
    let isExpanded: Bool
    let content: String
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 36, height: 36)
                        
                        Text("\(number)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.green)
                    }
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)
                }
                .contentShape(Rectangle())
                .padding(.vertical, 16)
                .padding(.horizontal)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded && !content.isEmpty {
                Text(content)
                    .foregroundColor(.gray)
                    .padding()
                    .padding(.leading, 16)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    NavigationView {
        ChartAIView(image: UIImage(named: "sample_chart") ?? UIImage())
    }
} 