# AI Trading Assistant

An iOS app that uses camera capture and Google's Gemini 2.0 Flash model to analyze trading charts and provide insights.

## Features

- Camera capture to take photos of trading charts
- Image preprocessing to enhance chart recognition
- Analysis of charts using Google's Gemini 2.0 Flash model
- Support for different analysis levels (Basic, Intermediate, Advanced)
- Trading calculator for position sizing and risk management
- Multi-language support

## Gemini 2.0 Flash Integration

This app integrates Google's Gemini 2.0 Flash model for image understanding, providing detailed analysis of trading charts. The model is capable of:

- Identifying market trends (bullish, bearish, sideways)
- Recognizing technical patterns
- Providing support and resistance levels
- Offering trading recommendations

## Setup Instructions

### Prerequisites

- Xcode 15.0+
- iOS 17.0+
- Google AI API key

### Installation

1. Clone the repository
2. Open the `AiTrading.xcodeproj` file in Xcode
3. Add the Google Generative AI Swift package:
   - In Xcode, go to File > Add Packages...
   - Enter the repository URL: `https://github.com/google-gemini/generative-ai-swift`
   - Click "Add Package"
4. Generate a Google API key from [Google AI Studio](https://ai.google.dev/)
5. Replace `YOUR_API_KEY` in the `GeminiService.swift` file with your actual API key
6. Build and run the application

### Configuration

- By default, the app uses a simulated analysis mode in Debug builds to enable development without API costs
- To use the real Gemini API in Debug builds:
  - Open `AppConfig.swift`
  - Change `USE_SIMULATED_ANALYSIS` to `false` for the Debug configuration

## Security Considerations

For production use, consider the following security measures:

- Do not embed API keys directly in the app
- Use a secure backend service to store and manage API keys
- Implement Firebase App Check or similar solutions for secure API access
- Apply proper rate limiting and request management

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Google Gemini](https://ai.google.dev/gemini-api/) - for the AI model
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - UI framework 