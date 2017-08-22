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

class ReadQRViewController: UIViewController, FoodSearchingController {
    //MARK: - Outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK: - Properties
    var dataSource: MutableFoodDataSource!
    
    weak var delegate: AddFoodToFridgeDelegate?
    
    var fromAdd: Bool = false
    
    var qrCodeMessage: String = "" {
        didSet {
            if fromAdd {
                actionButton.isEnabled = true
            }
        }
    }
    
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
                              AVMetadataObjectTypeQRCode,
                              AVMetadataObjectTypeITF14Code,
                              AVMetadataObjectTypeDataMatrixCode,
                              AVMetadataObjectTypeInterleaved2of5Code
                              ]
    
    
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
    
    //MARK: - Actions
    @IBAction func backToYourFood() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if !fromAdd {
            //Perform segue to seach food manually
            qrCodeMessage = ""
            performSegue(withIdentifier: "ChooseFoodType", sender: self)
        } else {
            //Perform unwind segue for added new barcode to new food
            //As is this view controller is already instantiated, that's why you must perform some cleanup after adding
            fromAdd = false
            performSegue(withIdentifier: "AddCodeToNewFood", sender: self)
        }
    }
    
    //MARK: - Methods
    
    //MARK: Working with DB
     func performSearch(withInfo info: String) {
        let wasAdded = dataSource.addFood(byQR: info)
        if wasAdded {
            statusLabel.text = statusLabelText[.Find]
            //TODO: Add animation of finding
            showAnimation(checked: wasAdded)
        } else {
            if info != qrCodeMessage {
                //TODO: Add animation of not founding
                showAnimation(checked: wasAdded)
            }
            statusLabel.text = statusLabelText[.NotFound]
        }
    }
    
    func showAnimation(checked: Bool) {
        var name: String
        if !checked {
            name = "warning"
        } else {
            name = "checked_done"
        }
        let animation = LOTAnimationView(name: name)
        view.addSubview(animation)
        animation.center = view.center
        animation.animationSpeed = 1.2
        animation.play(completion: { [weak self] _ in
            //At some reason, reverse animation or animationSpeed = -1 not working at this version of Lottie
            //That's why I'm using UIView.animate for removing animation
            UIView.animate(withDuration: 0.1, animations: {
                animation.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { _ in
                animation.removeFromSuperview()
                if let strongSelf = self {
                    //If food not found, than nothing happens, else-screen dismiss
                    strongSelf.delegate?.foodAddToFridge(strongSelf, successfuly: checked)
                }
            })
        })
    }

    //MARK: Prepare UI elements
    private func initiateCustomizeUIElements() {
        statusLabel.text = statusLabelText[.Searching]
        
        statusLabel.backgroundColor = UIColor.white
        statusLabel.layer.cornerRadius = elementsCornerRadius
        statusLabel.clipsToBounds = true
        
        actionButton.backgroundColor = UIColor.white
        actionButton.layer.cornerRadius = elementsCornerRadius
        customizeForStages()
    }
    
    private func customizeForStages() {
        if fromAdd {
            actionButton.setTitle(NSLocalizedString("Add code", comment: "Action Button title text for add barcode stage"), for: .normal)
            actionButton.isEnabled = false
        } else {
            actionButton.setTitle(NSLocalizedString("Choose food", comment: "Action Button title text for add food stage"), for: .normal)
        }
    }
    
    private func prepareBarcodeReader() {
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
            //TODO: Rewrite delegate for using another queue, YOU MUST NOT BLOCK MAIN QUEUE!
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
            catchErrorWithReader(error)
        }
    }
    
    private func catchErrorWithReader(_ error: NSError) {
        record(error: error)
        view.addSubview(messageLabel)
        messageLabel.setupMessage(with: captureVideoDeviceErrorMassage)
        statusLabel.isHidden = true
        statusLabel.text = statusLabelText[.Error] //change text for error, label will not be visible, but if it be, it will be show error
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackground(image: backgroundImage!)
        
        prepareBarcodeReader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initiateCustomizeUIElements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "ChooseFoodType":
            let destination = segue.destination as! ChooseFoodTypeTableViewController
            destination.dataSource = dataSource
            destination.delegate = delegate
        case "AddNewFood":
            fromAdd = false
        default:
            let error = NSError(domain: "ReadQRSegueError", code: 1, userInfo: ["SegueIdentifier":segue.identifier ?? "nil"])
            record(error: error)
        }
    }
    

}

//MARK: - Extention: AVCaptureMetadataOutputObjectsDelegate
extension ReadQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = .zero
            if fromAdd && !qrCodeMessage.isEmpty {
                //Save previous qr code info if you are in saving new food info mode
                statusLabel.text = statusLabelText[.SearchDone]
            } else {
                //Clean qr code info from previous search if you are in reading mode
                qrCodeMessage = ""
                statusLabel.text = statusLabelText[.Searching]
            }
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                statusLabel.text = statusLabelText[.SearchDone]
                if !fromAdd {
                    performSearch(withInfo: metadataObj.stringValue)
                }
                qrCodeMessage = metadataObj.stringValue
            }
        }
    }
}
