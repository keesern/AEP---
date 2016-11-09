import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController{
    
    @IBOutlet weak var cameraView: CameraView!
    let session = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let sessionQueue = dispatch_queue_create("CameraRecord", nil)
    var movieFileOutput: AVCaptureMovieFileOutput? = nil
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.session = session
        
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
        case .Authorized:
            break
        case.NotDetermined:
            dispatch_suspend(sessionQueue)
            //AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo){
            //    [weak strongSelf = self] granted in
            //    strongSelf?.sessionQueue.resume()
            //}
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) {
                [weak strongSelf = self] granted in
                dispatch_resume(strongSelf!.sessionQueue)
            }
        default:
            print()
        }
        dispatch_async(sessionQueue) { [weak strongSelf = self] in
            strongSelf?.configureSession()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispatch_async(sessionQueue)  { [weak strongSelf = self] in
            strongSelf?.session.startRunning()
        }
    }
    @IBAction func touchUpRecord(_ recordButton: UIButton) {
        guard let movieFileOutput = self.movieFileOutput else {return}
        
        recordButton.enabled = false
        let videoPreviewLayerOrientation = cameraView.videoPreviewLayer.connection.videoOrientation
        
        dispatch_async(sessionQueue)  { [weak strongSelf = self] in
            if !movieFileOutput.recording {
                let movieFileOutputConnection = self.movieFileOutput?.connectionWithMediaType(AVMediaTypeVideo)
                movieFileOutputConnection?.videoOrientation = videoPreviewLayerOrientation
                
                // Start recording to a temporary file.
                let outputFileName = NSUUID().UUIDString
                let outputFilePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent((outputFileName as NSString).stringByAppendingPathExtension("mov")!)
                movieFileOutput.startRecordingToOutputFileURL(NSURL(fileURLWithPath: outputFilePath), recordingDelegate: strongSelf)
            }
            else {
                movieFileOutput.stopRecording()
            }
        }
        
    }
    
}

extension ViewController{
    func configureSession() {
        session.beginConfiguration()
        //get camera
        var defaultVideoDevice: AVCaptureDevice?
        if let frontCameraDevice = AVCaptureDevice.defaultDeviceWithDeviceType(AVCaptureDeviceTypeBuiltInWideAngleCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.Front) {
            defaultVideoDevice = frontCameraDevice
        }
        let videoDeviceInput = try? AVCaptureDeviceInput(device: defaultVideoDevice)
        if session.canAddInput(videoDeviceInput) {
            session.addInput(videoDeviceInput)
            self.videoDeviceInput = videoDeviceInput
        }
        else {
            print("Error can not add")
            session.commitConfiguration()
            return
        }
        
        //get audio
        let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        let audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice)
        if session.canAddInput(audioDeviceInput) {
            session.addInput(audioDeviceInput)
        }
        else {
            print("Error can not add")
            session.commitConfiguration()
            return
        }
        //trans to movie
        let movieFileOutput = AVCaptureMovieFileOutput()
        if self.session.canAddOutput(movieFileOutput) {
            self.session.addOutput(movieFileOutput)
            self.session.sessionPreset = AVCaptureSessionPresetHigh
            if let connection = movieFileOutput.connectionWithMediaType(AVMediaTypeVideo) {
                if connection.supportsVideoStabilization {
                    connection.preferredVideoStabilizationMode = .Auto
                }
            }
            self.session.commitConfiguration()
            self.movieFileOutput = movieFileOutput
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playerViewController = segue.destinationViewController as! PlayerViewController
        playerViewController.urlFile = sender as? NSURL
    }
}

extension ViewController : AVCaptureFileOutputRecordingDelegate {
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        dispatch_async(dispatch_get_main_queue(),{
            [weak strongSelf = self] in
            strongSelf?.recordButton.enabled = true
            strongSelf?.recordButton.setTitle("Stop", forState: [])
            }
        )
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        guard error == nil else {
            return
        }
        PHPhotoLibrary.requestAuthorization{
            status in
            if status == .Authorized{
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    let creationRequest = PHAssetCreationRequest.creationRequestForAsset()
                    creationRequest.addResourceWithType(PHAssetResourceType.Video, fileURL: outputFileURL, options: options)
                    }, completionHandler: { success, error in
                        print("Error: \(error)")
                })
            }
        }
        dispatch_async(dispatch_get_main_queue(),{
            [weak strongSelf = self] in
            strongSelf?.recordButton.enabled = true
            strongSelf?.recordButton.setTitle("Record", forState: [])
            self.performSegueWithIdentifier("recordtoplayer", sender: outputFileURL)
            }
        )
        
    }
}















