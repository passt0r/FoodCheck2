//
//  ReadQRViewController.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 10.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

class ReadQRViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK: - Properties
    var dataSource: MutableFoodDataSource!
    
    fileprivate var fromAdd: Bool = false
    
    fileprivate var qrCodeMessage: String = ""
    
    fileprivate var capturedSession: AVCaptureSession?
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var qrCodeFrameView: UIView?
    
    fileprivate let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    private lazy var messageLabel: UILabel = {
        return generateMassageLabel()
    }()
    
    fileprivate enum readerStatus {
        case Searching
        case SearchDone
        case NotFound
        case Find
        case Error
    }
    
    fileprivate let statusLabelText: [ readerStatus : String ] = [
        readerStatus.Searching: NSLocalizedString("Searching...", comment: "QR reader status label searching message"),
        readerStatus.SearchDone: NSLocalizedString("Done", comment: "QR reader status label searchDone message"),
        readerStatus.NotFound: NSLocalizedString("Not Found", comment: "QR reader status label not found message"),
        readerStatus.Find: NSLocalizedString("Find", comment: "QR reader status label find message"),
        readerStatus.Error: NSLocalizedString("Error", comment: "QR reader status label error message")
    ]
    
    private let captureVideoDeviceErrorMassage = NSLocalizedString("Oops, we get some problems with your camera", comment: "Error massage when get capture device error")
    
    private let elementsCornerRadius: CGFloat = 10
    
    @IBAction func backToYourFood() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if !fromAdd {
            performSegue(withIdentifier: "", sender: sender)
        } else {
            
        }
    }
    
    private func customizeForStages() {
        if fromAdd {
            actionButton.titleLabel?.text = NSLocalizedString("Add code", comment: "Action Button title text for add barcode stage")
            actionButton.isEnabled = false
        } else {
            actionButton.titleLabel?.text = NSLocalizedString("Choose food", comment: "Action Button title text for add food stage")
        }
    }
    
    //MARK: Working with DB
    fileprivate func performSearch(withCode code: String) {
        let wasAdded = dataSource.addFood(byQR: code)
        if wasAdded {
            statusLabel.text = statusLabelText[.Find]
        } else {
            statusLabel.text = statusLabelText[.NotFound]
        }
    }

    //MARK: Prepare UI elements
    private func initiateCustomizeUIElements() {
        statusLabel.text = statusLabelText[.Searching]
        
        //statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.backgroundColor = UIColor.white
        statusLabel.layer.cornerRadius = elementsCornerRadius
        statusLabel.clipsToBounds = true
        
        actionButton.backgroundColor = UIColor.white
        actionButton.layer.cornerRadius = elementsCornerRadius
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackground(image: UIImage(named: "Fridge_background")!)
        initiateCustomizeUIElements()
        
        //Get device for capture video info
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            //Get input using previous getted capture device
            let input = try AVCaptureDeviceInput(device: captureDevice)
            //Instantiate capture session
            let captureSession = AVCaptureSession()
            //Add input to capture session
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            //add videoPreview layer as sublayer to self.view layer to display video from camera to screen
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            //start video capturing
            captureSession.startRunning()
            view.bringSubview(toFront: statusLabel)
            view.bringSubview(toFront: actionButton)
            
            //add greenbox around barcode
            qrCodeFrameView = UIView()
            
            if let qrcodeFrameView = qrCodeFrameView {
                qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView?.layer.borderWidth = 2
                view.addSubview(qrcodeFrameView)
                view.bringSubview(toFront: qrcodeFrameView)
            }
            
        } catch let error as NSError {
            // catch error when capture device input
            record(error: error)
            view.addSubview(messageLabel)
            messageLabel.setupMessage(with: captureVideoDeviceErrorMassage)
            statusLabel.text = statusLabelText[.Error]
            statusLabel.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ReadQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = .zero
            if fromAdd && !qrCodeMessage.isEmpty {
                statusLabel.text = statusLabelText[.SearchDone]
            } else {
                statusLabel.text = statusLabelText[.Searching]
            }
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                qrCodeMessage = metadataObj.stringValue
                statusLabel.text = statusLabelText[.SearchDone]
                if !fromAdd {
                    performSearch(withCode: qrCodeMessage)
                }
            }
        }
    }
}
