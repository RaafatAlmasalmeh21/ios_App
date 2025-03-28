import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraService = CameraService()
    @State private var currentZoom: CGFloat = 1.0
    @State private var showAnalysis = false
    @State private var selectedAnalysisLevel: AnalysisLevel = .basic
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header
                HStack {
                    Text("Chart Capture")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Analysis level picker
                    Menu {
                        ForEach(AnalysisLevel.allCases) { level in
                            Button(action: {
                                selectedAnalysisLevel = level
                            }) {
                                Text(level.rawValue)
                                if selectedAnalysisLevel == level {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedAnalysisLevel.rawValue)
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
                    if !cameraService.isTaken {
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
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    // Camera frame guide
                    if !cameraService.isTaken {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                            .padding(40)
                            .opacity(0.6)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Instructions
                if !cameraService.isTaken {
                    Text("Position the chart within the frame")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                        .padding()
                }
                
                // Controls
                HStack(spacing: 60) {
                    if cameraService.isTaken {
                        Button(action: {
                            cameraService.retake()
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        
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
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                cameraService.startSession()
            case .inactive:
                cameraService.stopSession()
            case .background:
                cameraService.stopSession()
            @unknown default:
                break
            }
        }
        .onAppear {
            cameraService.checkPermissions()
            cameraService.startSession()
        }
        .onDisappear {
            cameraService.stopSession()
        }
        .navigationDestination(isPresented: $showAnalysis) {
            if let image = cameraService.capturedImage {
                AnalysisView(
                    image: image,
                    level: selectedAnalysisLevel
                )
            }
        }
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