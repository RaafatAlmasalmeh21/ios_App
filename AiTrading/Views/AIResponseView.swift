import SwiftUI

struct AIResponseView: View {
    let analysisText: String
    @State private var showRawResponse = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                showRawResponse.toggle()
            }) {
                HStack {
                    Image(systemName: "brain")
                    Text(showRawResponse ? "Hide AI Response" : "Show AI Response")
                    Spacer()
                    Image(systemName: showRawResponse ? "chevron.up" : "chevron.down")
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            if showRawResponse {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Gemini 2.0 Flash Analysis")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(analysisText)
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    HStack {
                        Spacer()
                        Text("Analysis powered by Google Gemini 2.0 Flash")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                .padding(.vertical, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: showRawResponse)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    AIResponseView(
        analysisText: """
        Analysis of Chart:
        
        Market Trend: Bullish
        
        Support and Resistance Levels:
        - Support: $120.50, $118.75
        - Resistance: $130.25, $135.40
        
        Technical Patterns:
        - Cup and Handle formation
        - RSI showing strength at 65
        - Moving averages aligned bullishly
        
        Trading Recommendation:
        Consider entering long positions with a stop loss at $119.00 and targets at $132.00 and $137.50. The chart shows strong momentum with increasing volume, suggesting continued upward movement.
        """
    )
} 