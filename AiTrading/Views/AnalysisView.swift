import SwiftUI

struct AnalysisView: View {
    let image: UIImage
    let level: AnalysisLevel
    
    @StateObject private var analysisService = AnalysisService()
    @State private var showCalculator = false
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
                        ResultSectionView(title: "market_trend".localized) {
                            HStack {
                                Circle()
                                    .fill(result.trend.color)
                                    .frame(width: 14, height: 14)
                                
                                Text(result.trend.localizedRawValue)
                                    .font(.headline)
                                
                                Spacer()
                                
                                // Confidence level
                                if result.confidence > 0 {
                                    HStack(spacing: 4) {
                                        LocalizedText("confidence")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Text(String(format: "%.1f%%", result.confidence * 100))
                                            .font(.caption.bold())
                                    }
                                }
                            }
                        }
                        
                        // Recommendation
                        ResultSectionView(title: "recommendation".localized) {
                            Text(result.recommendation)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        // Entry and exit points
                        if !result.entryPoints.isEmpty || !result.exitPoints.isEmpty {
                            ResultSectionView(title: "key_price_levels".localized) {
                                VStack(alignment: .leading, spacing: 8) {
                                    if !result.entryPoints.isEmpty {
                                        HStack(alignment: .top) {
                                            LocalizedText("entry")
                                                .foregroundColor(.secondary)
                                                .frame(width: 80, alignment: .leading)
                                            
                                            VStack(alignment: .leading) {
                                                ForEach(result.entryPoints, id: \.self) { point in
                                                    Text(String(format: "%.2f", point))
                                                        .foregroundColor(.green)
                                                }
                                            }
                                        }
                                    }
                                    
                                    if !result.exitPoints.isEmpty {
                                        HStack(alignment: .top) {
                                            LocalizedText("exit")
                                                .foregroundColor(.secondary)
                                                .frame(width: 80, alignment: .leading)
                                            
                                            VStack(alignment: .leading) {
                                                ForEach(result.exitPoints, id: \.self) { point in
                                                    Text(String(format: "%.2f", point))
                                                        .foregroundColor(.blue)
                                                }
                                            }
                                        }
                                    }
                                    
                                    if !result.supportLevels.isEmpty {
                                        HStack(alignment: .top) {
                                            LocalizedText("support")
                                                .foregroundColor(.secondary)
                                                .frame(width: 80, alignment: .leading)
                                            
                                            VStack(alignment: .leading) {
                                                ForEach(result.supportLevels, id: \.self) { level in
                                                    Text(String(format: "%.2f", level))
                                                }
                                            }
                                        }
                                    }
                                    
                                    if !result.resistanceLevels.isEmpty {
                                        HStack(alignment: .top) {
                                            LocalizedText("resistance")
                                                .foregroundColor(.secondary)
                                                .frame(width: 80, alignment: .leading)
                                            
                                            VStack(alignment: .leading) {
                                                ForEach(result.resistanceLevels, id: \.self) { level in
                                                    Text(String(format: "%.2f", level))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Technical indicators
                        if !result.indicators.isEmpty {
                            ResultSectionView(title: "technical_indicators".localized) {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(Array(result.indicators.keys.sorted()), id: \.self) { key in
                                        if let value = result.indicators[key] {
                                            HStack(alignment: .top) {
                                                Text("\(key):")
                                                    .foregroundColor(.secondary)
                                                    .frame(width: 80, alignment: .leading)
                                                
                                                Text(value)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Patterns
                        if !result.patterns.isEmpty {
                            ResultSectionView(title: "patterns_detected".localized) {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(result.patterns, id: \.self) { pattern in
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.caption)
                                            
                                            Text(pattern)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Detailed analysis for advanced level
                        if !result.detailedAnalysis.isEmpty {
                            ResultSectionView(title: "detailed_analysis".localized) {
                                Text(result.detailedAnalysis)
                                    .fixedSize(horizontal: false, vertical: true)
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
                                LocalizedText("trading_calculator")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
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
        .onChange(of: localizationManager.currentLanguage) { _ in
            // Reanalyze the image when language changes
            analysisService.analyzeImage(image, level: level)
        }
        .navigationDestination(isPresented: $showCalculator) {
            TradingCalculatorView(
                entryPrice: analysisService.result?.entryPoints.first ?? 0.0,
                exitPrice: analysisService.result?.exitPoints.first ?? 0.0
            )
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
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content
                .padding(.horizontal, 4)
                .padding(.bottom, 8)
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(10)
        .padding(.horizontal)
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

#Preview {
    NavigationStack {
        AnalysisView(
            image: UIImage(systemName: "chart.xyaxis.line")!,
            level: .advanced
        )
    }
} 