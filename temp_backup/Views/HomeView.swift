import SwiftUI

struct HomeView: View {
    @State private var showCamera = false
    @State private var showCalculator = false
    @State private var showHistory = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.black]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // App logo and title
                    VStack(spacing: 15) {
                        Image(systemName: "chart.xyaxis.line")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                        
                        Text("AI Trading Assistant")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Analyze charts with AI-powered insights")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    // Main action buttons
                    VStack(spacing: 20) {
                        FeatureButton(
                            title: "Capture Chart",
                            icon: "camera.fill",
                            description: "Take a photo of a chart for AI analysis",
                            color: .blue
                        ) {
                            showCamera = true
                        }
                        
                        FeatureButton(
                            title: "Trading Calculator",
                            icon: "function",
                            description: "Calculate position size and risk metrics",
                            color: .green
                        ) {
                            showCalculator = true
                        }
                        
                        FeatureButton(
                            title: "Analysis History",
                            icon: "clock.fill",
                            description: "View your previous chart analyses",
                            color: .orange
                        ) {
                            showHistory = true
                        }
                    }
                    
                    Spacer()
                    
                    // Information section
                    VStack(spacing: 10) {
                        Text("How It Works")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Capture a candlestick chart using your camera, then use AI to get analysis at basic, intermediate, or advanced levels. Calculate optimal position sizes based on your risk tolerance.")
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
                Text("Analysis History") // Placeholder for history view
                    .navigationTitle("History")
            }
        }
    }
}

struct FeatureButton: View {
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
    }
}

#Preview {
    HomeView()
} 