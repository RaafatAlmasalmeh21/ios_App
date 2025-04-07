import SwiftUI

struct AIResponseView: View {
    let analysisText: String
    @State private var showRawResponse = false
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Toggle button
            Button(action: {
                showRawResponse.toggle()
            }) {
                HStack {
                    Image(systemName: "ellipsis.message")
                        .foregroundColor(.blue)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(showRawResponse ? "hide_ai_response".localized : "show_ai_response".localized)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    
                    Image(systemName: showRawResponse ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
            
            if showRawResponse {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "brain")
                            .font(.title3)
                            .foregroundColor(.blue)
                        
                        Text("gemini_flash_analysis".localized)
                            .font(.headline)
                    }
                    .padding(.bottom, 5)
                    
                    Text(analysisText)
                        .font(.body)
                        .lineSpacing(6)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.secondarySystemBackground))
                        )
                    
                    HStack {
                        Spacer()
                        
                        Text("powered_by_gemini".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
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
            }
        }
        .id(localizationManager.currentLanguage.rawValue)
    }
}

// Simple preview
#Preview {
    AIResponseView(
        analysisText: "Sample analysis text for preview purposes."
    )
} 