import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraService = CameraService()
    @State private var currentZoom: CGFloat = 1.0
    @State private var showAnalysis = false
    @State private var selectedAnalysisLevel: AnalysisLevel = .basic
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    // For photo library picker
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header
                HStack {
                    LocalizedText("chart_capture")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Analysis level picker
                    Menu {
                        ForEach(AnalysisLevel.allCases) { level in
                            Button(action: {
                                selectedAnalysisLevel = level
                            }) {
                                Text(level.localizedRawValue)
                                if selectedAnalysisLevel == level {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedAnalysisLevel.localizedRawValue)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding(8)
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(8)
                    }
                }
                .padding()
                
                // Camera preview or captured image
                ZStack {
                    if let selectedImage = selectedImage {
                        // Show selected image from photo library
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if !cameraService.isTaken {
                        // Show camera preview
                        CameraPreviewView(cameraService: cameraService)
                            .gesture(MagnificationGesture()
                                .onChanged { value in
                                    self.currentZoom = value
                                }
                                .onEnded { _ in
                                    // Apply zoom (would be implemented in a real app)
                                }
                            )
                    } else if let image = cameraService.capturedImage {
                        // Show captured image
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    // Camera frame guide
                    if !cameraService.isTaken && selectedImage == nil {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                            .padding(40)
                            .opacity(0.6)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Instructions
                if !cameraService.isTaken && selectedImage == nil {
                    LocalizedText("position_chart")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                        .padding()
                }
                
                // Controls
                HStack(spacing: 40) {
                    if selectedImage != nil || cameraService.isTaken {
                        // Back button
                        Button(action: {
                            selectedImage = nil
                            cameraService.retake()
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        
                        // Analyze button
                        Button(action: {
                            showAnalysis = true
                        }) {
                            Image(systemName: "chart.xyaxis.line")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    } else {
                        // Photo library button
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.title)
                                .padding()
                                .background(Color.gray.opacity(0.8))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        
                        // Camera button
                        Button(action: {
                            cameraService.takePicture()
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 80, height: 80)
                                )
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    // Stop camera session if image was selected
                    if selectedImage != nil {
                        cameraService.stopSession()
                    }
                }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                // Only start camera if we don't have a selected image
                if selectedImage == nil {
                    cameraService.startSession()
                }
            case .inactive:
                cameraService.stopSession()
            case .background:
                cameraService.stopSession()
            @unknown default:
                break
            }
        }
        .onAppear {
            // Only start camera if we don't have a selected image
            if selectedImage == nil {
                cameraService.checkPermissions()
                cameraService.startSession()
            }
        }
        .onDisappear {
            cameraService.stopSession()
        }
        .navigationDestination(isPresented: $showAnalysis) {
            if let image = selectedImage ?? cameraService.capturedImage {
                AnalysisView(
                    image: image,
                    level: selectedAnalysisLevel
                )
            }
        }
        .id(localizationManager.currentLanguage.rawValue) // Force refresh when language changes
        .localized() // Apply RTL layout for Arabic
    }
}

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var cameraService: CameraService
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        DispatchQueue.main.async {
            cameraService.preview = AVCaptureVideoPreviewLayer(session: cameraService.session)
            cameraService.preview?.frame = view.frame
            cameraService.preview?.videoGravity = .resizeAspectFill
            
            view.layer.addSublayer(cameraService.preview!)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update view if needed
    }
}

#Preview {
    NavigationStack {
        CameraView()
    }
} 