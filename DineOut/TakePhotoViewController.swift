//
//  TakePhotoViewController.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 6/25/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class TakePhotoViewController: UIViewController {
    
    
    @IBOutlet weak var camPreview: UIView!
    var focusMarker: UIImageView!
    var exposureMarker: UIImageView!
    var resetMarker: UIImageView!
    var imageTaken: UIImage!
    fileprivate var adjustingExposureContext: String = ""
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    let imageOutput = AVCaptureStillImageOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        setupPreview()
        startSession()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSession() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setup device input: \(error)")
        }
        
        imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        
        if captureSession.canAddOutput(imageOutput) {
            captureSession.addOutput(imageOutput)
        }
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = camPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
        
        // Attach tap recognizer for focus & exposure.
        let tapForFocus = UITapGestureRecognizer(target: self, action: #selector(TakePhotoViewController.tapToFocus(_:)))
        tapForFocus.numberOfTapsRequired = 1
        
        let tapForExposure = UITapGestureRecognizer(target: self, action: #selector(TakePhotoViewController.tapToExpose(_:)))
        tapForExposure.numberOfTapsRequired = 2
        
        let tapForReset = UITapGestureRecognizer(target: self, action: #selector(TakePhotoViewController.resetFocusAndExposure))
        tapForReset.numberOfTapsRequired = 2
        tapForReset.numberOfTouchesRequired = 2
        
        camPreview.addGestureRecognizer(tapForFocus)
        camPreview.addGestureRecognizer(tapForExposure)
        camPreview.addGestureRecognizer(tapForReset)
        tapForFocus.require(toFail: tapForExposure)
        
        // Create marker views.
        focusMarker = imageViewWithImage("Focus_Point")
        exposureMarker = imageViewWithImage("Exposure_Point")
        resetMarker = imageViewWithImage("Reset_Point")
        camPreview.addSubview(focusMarker)
        camPreview.addSubview(exposureMarker)
        camPreview.addSubview(resetMarker)
    }
    
    func startSession() {
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
    }
    
    // MARK: Focus Methods
    func tapToFocus(_ recognizer: UIGestureRecognizer) {
        if activeInput.device.isFocusPointOfInterestSupported {
            let point = recognizer.location(in: camPreview)
            let pointOfInterest = previewLayer.captureDevicePointOfInterest(for: point)
            showMarkerAtPoint(point, marker: focusMarker)
            focusAtPoint(pointOfInterest)
        }
    }
    
    func focusAtPoint(_ point: CGPoint) {
        let device = activeInput.device
        // Make sure the device supports focus on POI and Auto Focus.
        if (device?.isFocusPointOfInterestSupported)! &&
            (device?.isFocusModeSupported(AVCaptureFocusMode.autoFocus))! {
            do {
                try device?.lockForConfiguration()
                device?.focusPointOfInterest = point
                device?.focusMode = AVCaptureFocusMode.autoFocus
                device?.unlockForConfiguration()
            } catch {
                print("Error focusing on POI: \(error)")
            }
        }
    }
    
    // MARK: Exposure Methods
    func tapToExpose(_ recognizer: UIGestureRecognizer) {
        if activeInput.device.isExposurePointOfInterestSupported {
            let point = recognizer.location(in: camPreview)
            let pointOfInterest = previewLayer.captureDevicePointOfInterest(for: point)
            showMarkerAtPoint(point, marker: exposureMarker)
            exposeAtPoint(pointOfInterest)
        }
    }
    
    func exposeAtPoint(_ point: CGPoint) {
        let device = activeInput.device
        if (device?.isExposurePointOfInterestSupported)! &&
            (device?.isExposureModeSupported(AVCaptureExposureMode.continuousAutoExposure))! {
            do {
                try device?.lockForConfiguration()
                device?.exposurePointOfInterest = point
                device?.exposureMode = AVCaptureExposureMode.continuousAutoExposure
                
                if (device?.isExposureModeSupported(AVCaptureExposureMode.locked))! {
                    device?.addObserver(self,
                                        forKeyPath: "adjustingExposure",
                                        options: NSKeyValueObservingOptions.new,
                                        context: &adjustingExposureContext)
                    
                    device?.unlockForConfiguration()
                }
            } catch {
                print("Error exposing on POI: \(error)")
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if context == &adjustingExposureContext {
            let device = object as! AVCaptureDevice
            if !device.isAdjustingExposure &&
                device.isExposureModeSupported(AVCaptureExposureMode.locked) {
                (object as AnyObject).removeObserver(self,
                                                     forKeyPath: "adjustingExposure",
                                                     context: &adjustingExposureContext)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        try device.lockForConfiguration()
                        device.exposureMode = AVCaptureExposureMode.locked
                        device.unlockForConfiguration()
                    } catch {
                        print("Error exposing on POI: \(error)")
                    }
                })
                
            }
        } else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
        }
    }
    
    // MARK: Reset Focus and Exposure
    func resetFocusAndExposure() {
        let device = activeInput.device
        let focusMode = AVCaptureFocusMode.continuousAutoFocus
        let exposureMode = AVCaptureExposureMode.continuousAutoExposure
        
        let canResetFocus = (device?.isFocusPointOfInterestSupported)! &&
            (device?.isFocusModeSupported(focusMode))!
        let canResetExposure = (device?.isExposurePointOfInterestSupported)! &&
            (device?.isExposureModeSupported(exposureMode))!
        
        let center = CGPoint(x: 0.5, y: 0.5)
        
        if canResetFocus || canResetExposure {
            let markerCenter = previewLayer.pointForCaptureDevicePoint(ofInterest: center)
            showMarkerAtPoint(markerCenter, marker: resetMarker)
        }
        
        do {
            try device?.lockForConfiguration()
            if canResetFocus {
                device?.focusMode = focusMode
                device?.focusPointOfInterest = center
            }
            if canResetExposure {
                device?.exposureMode = exposureMode
                device?.exposurePointOfInterest = center
            }
            
            device?.unlockForConfiguration()
        } catch {
            print("Error resetting focus & exposure: \(error)")
        }
    }
    
    func showMarkerAtPoint(_ point: CGPoint, marker: UIImageView) {
        marker.center = point
        marker.isHidden = false
        
        UIView.animate(withDuration: 0.15,
                       delay: 0.0,
                       options: UIViewAnimationOptions(),
                       animations: { () -> Void in
                        marker.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
        }) { (Bool) -> Void in
            let delay = 0.5
            let popTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime, execute: { () -> Void in
                marker.isHidden = true
                marker.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - Helpers
    func savePhotoToLibrary(_ image: UIImage) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success: Bool, error: Error?) -> Void in
            if success {
                print("Successfully saved photo to library")
            } else {
                print("Error writing to photo library: \(error!.localizedDescription)")
            }
        }
    }
    
    func imageViewWithImage(_ name: String) -> UIImageView {
        let view = UIImageView()
        let image = UIImage(named: name)
        view.image = image
        view.sizeToFit()
        view.isHidden = true
        
        return view
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }
    
    @IBAction func capturePhoto(_ sender: Any) {
        let connection = imageOutput.connection(withMediaType: AVMediaTypeVideo)
        if (connection?.isVideoOrientationSupported)! {
            connection?.videoOrientation = currentVideoOrientation()
        }
        
        imageOutput.captureStillImageAsynchronously(from: connection) {
            (sampleBuffer: CMSampleBuffer!, error: Error!) -> Void in
            if sampleBuffer != nil {
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let image = UIImage(data: imageData!)
                self.savePhotoToLibrary(image!)
                
                // TODO: if image is not nil, send data to backend and process json
                // Present Add Recipients view to add friends
                // Once friend selection is done, if response has came back from backend, populate view for the user item binding, otherwise show spinner till data is ready
            } else {
                print("Error capturing photo: \(error.localizedDescription)")
            }
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AddRecipientsViewController {
            viewController.transactionMethod = .splitBill
        }
    }
}
