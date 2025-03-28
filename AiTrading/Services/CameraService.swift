import Foundation
import AVFoundation
import UIKit
import SwiftUI

class CameraService: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer?
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    @Published var isTaken = false
    @Published var capturedImage: UIImage?
    @Published var isProcessing = false
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    // Camera setup
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .authorized:
            setupCamera()
        case .denied, .restricted:
            break // Handle in UI
        @unknown default:
            break
        }
    }
    
    func setupCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.session.beginConfiguration()
            
            // Add input
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("No back camera found")
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
                
                // Add output
                if self.session.canAddOutput(self.output) {
                    self.session.addOutput(self.output)
                }
                
                self.session.commitConfiguration()
            } catch {
                print("Error setting up camera: \(error.localizedDescription)")
            }
        }
    }
    
    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func takePicture() {
        // Ensure we're on the main thread when getting UI-related calls
        DispatchQueue.main.async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.isTaken = true
        }
    }
    
    func retake() {
        // Ensure we're on the main thread when updating UI state
        DispatchQueue.main.async {
            self.isTaken = false
            self.capturedImage = nil
        }
    }
    
    deinit {
        // Make sure we stop on the session queue when deallocated
        sessionQueue.async { [weak session] in
            session?.stopRunning()
        }
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Failed to create image from data")
            return
        }
        
        // Update UI on main thread
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
} 