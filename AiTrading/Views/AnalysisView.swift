import SwiftUI

struct AnalysisView: View {
    let image: UIImage
    let level: AnalysisLevel
    
    @StateObject private var analysisService = AnalysisService()
    @State private var showCalculator = false
    @State private var showChartAI = false
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header section
                VStack(alignment: .leading) {
                    LocalizedText("chart_analysis")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(String(format: "level".localized, level.localizedRawValue))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Analysis timestamp
                    if let result = analysisService.result {
                        Text(String(format: "analyzed_on".localized, result.timestamp.formatted(date: .abbreviated, time: .shortened)))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                // Chart image
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                // Loading indicator or analysis results
                if analysisService.isAnalyzing {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        LocalizedText("analyzing_chart")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else if let error = analysisService.error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        
                        Text(String(format: "error_title".localized, error))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else if let result = analysisService.result {
                    // Analysis results
                    Group {
                        // Market trend
                        ResultSectionView(title: "market_trend".localized, iconName: "chart.bar.fill") {
                            VStack(spacing: 16) {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 6) {
                                        Circle()
                                            .fill(result.trend.color)
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Image(systemName: result.trend == .bullish ? "arrow.up" : 
                                                                   result.trend == .bearish ? "arrow.down" : "arrow.left.and.right")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(.white)
                                            )
                                        
                                        Text(result.trend.localizedRawValue)
                                            .font(.headline.bold())
                                            .foregroundColor(result.trend.color)
                                    }
                                    Spacer()
                                }
                                
                                // Confidence indicator
                                if result.confidence > 0 {
                                    VStack(spacing: 4) {
                                        HStack {
                                            LocalizedText("confidence")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            Spacer()
                                            
                                            Text(String(format: "%.1f%%", result.confidence * 100))
                                                .font(.subheadline.bold())
                                        }
                                        
                                        // Confidence progress bar
                                        GeometryReader { geometry in
                                            ZStack(alignment: .leading) {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: geometry.size.width, height: 8)
                                                    .cornerRadius(4)
                                                
                                                Rectangle()
                                                    .fill(result.trend.color)
                                                    .frame(width: geometry.size.width * CGFloat(result.confidence), height: 8)
                                                    .cornerRadius(4)
                                            }
                                        }
                                        .frame(height: 8)
                                    }
                                }
                            }
                        }
                        
                        // Recommendation
                        ResultSectionView(title: "recommendation".localized, iconName: "hand.thumbsup.fill") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(result.recommendation)
                                    .font(.body)
                                    .lineSpacing(6)
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(UIColor.secondarySystemBackground))
                                    )
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Entry and exit points
                        if !result.entryPoints.isEmpty || !result.exitPoints.isEmpty || !result.supportLevels.isEmpty || !result.resistanceLevels.isEmpty {
                            ResultSectionView(title: "key_price_levels".localized, iconName: "dollarsign.circle.fill") {
                                VStack(alignment: .leading, spacing: 16) {
                                    // Entry points
                                    if !result.entryPoints.isEmpty {
                                        PriceLevelRowView(title: "entry", values: result.entryPoints, color: .green, icon: "arrow.down.to.line")
                                    }
                                    
                                    // Exit points
                                    if !result.exitPoints.isEmpty {
                                        PriceLevelRowView(title: "exit", values: result.exitPoints, color: .blue, icon: "arrow.up.right.square")
                                    }
                                    
                                    // Support levels
                                    if !result.supportLevels.isEmpty {
                                        PriceLevelRowView(title: "support", values: result.supportLevels, color: .purple, icon: "arrow.down")
                                    }
                                    
                                    // Resistance levels
                                    if !result.resistanceLevels.isEmpty {
                                        PriceLevelRowView(title: "resistance", values: result.resistanceLevels, color: .orange, icon: "arrow.up")
                                    }
                                }
                            }
                        }
                        
                        // Technical indicators
                        if !result.indicators.isEmpty {
                            ResultSectionView(title: "technical_indicators".localized, iconName: "waveform.path.ecg") {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ], spacing: 16) {
                                    ForEach(Array(result.indicators.keys.sorted()), id: \.self) { key in
                                        if let value = result.indicators[key] {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(key)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                                
                                                HStack {
                                                    let isPositive = value.contains("Bullish") || value.contains("Above")
                                                    let isNegative = value.contains("Bearish") || value.contains("Below")
                                                    
                                                    Text(value)
                                                        .font(.system(.body, design: .rounded).bold())
                                                        .foregroundColor(isPositive ? .green : (isNegative ? .red : .primary))
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    
                                                    Spacer()
                                                }
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 8)
                                                .background(Color.secondary.opacity(0.1))
                                                .cornerRadius(6)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Patterns
                        if !result.patterns.isEmpty {
                            ResultSectionView(title: "patterns_detected".localized, iconName: "eye.fill") {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12)
                                ], spacing: 12) {
                                    ForEach(result.patterns, id: \.self) { pattern in
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.caption)
                                            
                                            Text(pattern)
                                                .font(.callout)
                                                .lineLimit(2)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                        }
                                        .padding(10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.green.opacity(0.1))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        
                        // Detailed analysis for advanced level
                        if !result.detailedAnalysis.isEmpty {
                            ResultSectionView(title: "detailed_analysis".localized, iconName: "info.circle.fill") {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(result.detailedAnalysis)
                                        .font(.body)
                                        .lineSpacing(6)
                                        .padding(16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(UIColor.secondarySystemBackground))
                                        )
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        
                        // Show AI response toggle (for Gemini output)
                        if !AppConfig.API.useGeminiAPI || !USE_SIMULATED_ANALYSIS {
                            AIResponseView(analysisText: result.detailedAnalysis)
                        }
                        
                        // Trading calculator button
                        Button(action: {
                            showCalculator = true
                        }) {
                            HStack {
                                Image(systemName: "function")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                LocalizedText("trading_calculator")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        
                        // Chart AI button
                        Button(action: {
                            showChartAI = true
                        }) {
                            HStack {
                                Image(systemName: "brain")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("Chart AI")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.purple.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }
            }
        }
        .navigationTitle("analysis".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    analysisService.analyzeImage(image, level: level)
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                }
            }
        }
        .onAppear {
            analysisService.analyzeImage(image, level: level)
        }
        .onChange(of: localizationManager.currentLanguage) { oldValue, newValue in
            // Reanalyze the image when language changes
            analysisService.analyzeImage(image, level: level)
        }
        .navigationDestination(isPresented: $showCalculator) {
            TradingCalculatorView(
                entryPrice: analysisService.result?.entryPoints.first ?? 0.0,
                exitPrice: analysisService.result?.exitPoints.first ?? 0.0
            )
        }
        .navigationDestination(isPresented: $showChartAI) {
            ChartAIView(image: image)
        }
        .localized() // Apply RTL layout for Arabic
        .id(localizationManager.currentLanguage.rawValue) // Force view refresh when language changes
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

// Helper view for results sections
struct ResultSectionView<Content: View>: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    let title: String
    let content: Content
    let iconName: String
    
    init(title: String, iconName: String = "chart.bar.fill", @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Divider()
                .background(Color.blue.opacity(0.5))
            
            content
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.vertical, 6)
        .id("\(localizationManager.currentLanguage.rawValue)_\(title)")
    }
}

// Date formatter for timestamps
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

// Price tag component for displaying price values
struct PriceTag: View {
    let price: Double
    let color: Color
    
    var body: some View {
        Text(String(format: "%.2f", price))
            .font(.system(.body, design: .monospaced))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
    }
}

// Price level row component for displaying price levels
struct PriceLevelRowView: View {
    let title: String
    let values: [Double]
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 22)
                
                Text(title.localized)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
            }
            
            if !values.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(values, id: \.self) { value in
                            PriceTag(price: value, color: color)
                        }
                    }
                    .padding(.leading, 26)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AnalysisView(
            image: UIImage(systemName: "chart.xyaxis.line")!,
            level: .advanced
        )
    }
} 