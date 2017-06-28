//
//  TakePhotoViewController.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 6/25/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit
import AVFoundation

class TakePhotoViewController: UIViewController {
  
  @IBOutlet weak var camPreview: UIView!
  
  let captureSession = AVCaptureSession()
  var previewLayer: AVCaptureVideoPreviewLayer!
  var activeInput: AVCaptureDeviceInput!
  let imageOutput = AVCaptureStillImageOutput()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setUpSession() {
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
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
