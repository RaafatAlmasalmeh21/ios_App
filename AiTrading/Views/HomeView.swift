import SwiftUI

struct HomeView: View {
    @State private var showCamera = false
    @State private var showCalculator = false
    @State private var showHistory = false
    @ObservedObject private var localizationManager = LocalizationManager.shared
    // Add state variables for image picker
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showAnalysisForSelectedImage = false
    @State private var selectedAnalysisLevel: AnalysisLevel = .basic
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.black]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // App logo and title with language selector
                    VStack(spacing: 15) {
                        HStack {
                            Spacer()
                            LanguageSelectorView()
                        }
                        .padding(.horizontal)
                        
                        Image(systemName: "chart.xyaxis.line")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                        
                        LocalizedText("app_title")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        LocalizedText("app_subtitle")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    // Main action buttons
                    VStack(spacing: 20) {
                        FeatureButton(
                            title: "capture_chart".localized,
                            icon: "camera.fill",
                            description: "capture_chart_description".localized,
                            color: .blue
                        ) {
                            showCamera = true
                        }
                        
                        // Add Gallery button
                        FeatureButton(
                            title: "select_chart".localized,
                            icon: "photo.fill",
                            description: "select_chart_description".localized,
                            color: .purple
                        ) {
                            showImagePicker = true
                        }
                        
                        FeatureButton(
                            title: "trading_calculator".localized,
                            icon: "function",
                            description: "trading_calculator_description".localized,
                            color: .green
                        ) {
                            showCalculator = true
                        }
                        
                        FeatureButton(
                            title: "analysis_history".localized,
                            icon: "clock.fill",
                            description: "analysis_history_description".localized,
                            color: .orange
                        ) {
                            showHistory = true
                        }
                    }
                    
                    Spacer()
                    
                    // Information section
                    VStack(spacing: 10) {
                        LocalizedText("how_it_works")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        LocalizedText("how_it_works_description")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationDestination(isPresented: $showCamera) {
                CameraView()
            }
            .navigationDestination(isPresented: $showCalculator) {
                TradingCalculatorView()
            }
            .navigationDestination(isPresented: $showHistory) {
                LocalizedText("analysis_history") // Placeholder for history view
                    .navigationTitle("history".localized)
            }
            .navigationDestination(isPresented: $showAnalysisForSelectedImage) {
                if let image = selectedImage {
                    AnalysisView(
                        image: image,
                        level: selectedAnalysisLevel
                    )
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
                    .onDisappear {
                        if selectedImage != nil {
                            // Show analysis level selection sheet when an image is selected
                            showAnalysisLevelSelection()
                        }
                    }
            }
        }
        .localized() // Apply RTL layout for Arabic
        .id(localizationManager.currentLanguage.rawValue) // Force view refresh when language changes
    }
    
    // Function to handle showing analysis level selection
    private func showAnalysisLevelSelection() {
        // In a real app, you might want to show a proper level selection UI
        // For simplicity, we'll just use the default level and proceed to analysis
        showAnalysisForSelectedImage = true
    }
}

struct FeatureButton: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    let title: String
    let icon: String
    let description: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
        }
        .id("\(localizationManager.currentLanguage.rawValue)_\(title)")
    }
}

#Preview {
    HomeView()
} 