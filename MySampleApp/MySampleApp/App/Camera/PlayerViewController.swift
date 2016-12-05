// Edited by: Kee Sern Chua

import UIKit
import AVFoundation
import MediaPlayer
import MediaPlayer
import AVKit
import AWSS3
import GoogleAPIClient
import GTMOAuth2

import WebKit
import MobileCoreServices
import AWSMobileHubHelper

class PlayerViewController: UIViewController {
    
    var prefix: String!

    @IBOutlet weak var playerView: PlayerView!
    let player = AVPlayer()
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    var playerItem: AVPlayerItem? = nil {
        didSet {
            player.replaceCurrentItemWithPlayerItem(self.playerItem)
        }
    }
    private var playerLayer: AVPlayerLayer? {
        return playerView.playerLayer
    }
    
    var urlFile:NSURL?
    var uploadUrl:NSURL?
    var username:String = "student1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let videoData = NSData(contentsOfURL: urlFile!)
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("vid1.mov")
        videoData?.writeToFile(dataPath, atomically: true)
        uploadUrl = NSURL(fileURLWithPath: dataPath as String)
        asset = AVURLAsset(URL: uploadUrl!, options: nil)
        playerView.playerLayer.player = player // should be this other
    }
    
    @IBAction func touchUpCloseButton(_ sender: UIButton) {
        player.pause()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func touchUpPlayButton(_ playerButton: UIButton) {
        playerButton.enabled = false
        player.play()
    }
    
    @IBAction func touchUpUpLoadButton(_ uploadButton: UIButton) {
        uploadButton.enabled = false
        uploadRecord()
    }
}

extension PlayerViewController{
    func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {
        newAsset.loadValuesAsynchronouslyForKeys([]) {
            dispatch_async(dispatch_get_main_queue(), {
                guard newAsset == self.asset else {
                    return
                }
                self.playerItem = AVPlayerItem(asset: newAsset)
                }
            )
        }
    }
    
    func uploadRecord(){
        
        countVideo.count += 1
        //===================Upload Start======================
        print("Upload video method called.")
        // setup variables for s3 upload request
        let s3bucket = "aepios-userfiles-mobilehub-1099679197"
        let fileType = "mp4"
        
        

        let userId = AWSIdentityManager.defaultIdentityManager().userName!
        
        
        //prepare upload request
        print("preparing upload request...")
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = s3bucket
        
        if(countVideo.count == 1)
        {
            //let key: String = "\(userId)/\("Lesson1")/1.mov"
            //self.uploadWithData(data, forKey: key)
            uploadRequest.key = "private/\(userId)/\("Lesson1")/1.mp4"
        }
        else if(countVideo.count == 2) {
            uploadRequest.key = "private/\(userId)/\("Lesson1")/2.mp4"
        }
        else if(countVideo.count == 3) {
            uploadRequest.key = "private/\(userId)/\("Lesson1")/3.mp4"
        }
        else if(countVideo.count == 4) {
            uploadRequest.key = "private/\(userId)/\("Lesson1")/4.mp4"
        }
        else
        {
            uploadRequest.key = "private/\(userId)/\("Lesson1")/5.mp4"
        }
        uploadRequest.body = uploadUrl
        uploadRequest.uploadProgress = { (bytesSent:Int64, totalBytesSent:Int64,  totalBytesExpectedToSend:Int64) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {() -> Void in
                print("SENT: \(bytesSent)\tTOTAL: \(totalBytesSent)\t/\(totalBytesExpectedToSend)")
            })
        }
        uploadRequest.contentType = "video/" + fileType
        print("upload request preparation complete.")
        AWSS3TransferManager.defaultS3TransferManager().upload(uploadRequest).continueWithBlock{ (task) -> AnyObject! in
            if let error = task.error{
                print("Upload failed (\(error)")
            }
            if let exception = task.exception{
                print("Upload failed (\(exception)")
            }
            if task.result != nil {
                let s3URL = NSURL(string: "http://s3.amazonaws.com/\(s3bucket)/\(uploadRequest.key!)")!
                print("Uploaded to: \n\(s3URL)")
            } else {
                print("***AWS S3 UPLOAD FAILED.")
            }
            
            return nil
        }
        //====================Upload End========================
        
        if(countVideo.count == 1)
        {
            video2()
        }
        else if(countVideo.count == 2) {
            video3()
        }
        else if(countVideo.count == 3) {
            video4()
        }
        else if(countVideo.count == 4) {
            video5()
        }
        else
        {
            /*let storyboard = UIStoryboard(name: "VideoView", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("VideoView") as UIViewController
            presentViewController(vc, animated: true, completion: nil)*/
            self.dismissViewControllerAnimated(true, completion: nil)
            /*dispatch_async(dispatch_get_main_queue(),{
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            dispatch_async(dispatch_get_main_queue(),{
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            dispatch_async(dispatch_get_main_queue(),{
                self.dismissViewControllerAnimated(true, completion: nil)
            })*/

        }
        
    }
    
    func video2(){
        let videoURL = NSURL(string: "https://s3.amazonaws.com/aepios-userfiles-mobilehub-1099679197/public/Lesson1Part2.mp4")
        let player = AVPlayer(URL: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: playerViewController.player!.currentItem)
    }
    
    func video3(){
        let videoURL = NSURL(string: "https://s3.amazonaws.com/aepios-userfiles-mobilehub-1099679197/public/Lesson1Part3.mp4")
        let player = AVPlayer(URL: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: playerViewController.player!.currentItem)
    }
    
    func video4(){
        let videoURL = NSURL(string: "https://s3.amazonaws.com/aepios-userfiles-mobilehub-1099679197/public/Lesson1Part4.mp4")
        let player = AVPlayer(URL: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: playerViewController.player!.currentItem)
    }
    
    
    func video5(){
        let videoURL = NSURL(string: "https://s3.amazonaws.com/aepios-userfiles-mobilehub-1099679197/public/Lesson1Part5.mp4")
        let player = AVPlayer(URL: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: playerViewController.player!.currentItem)
    }
    
    
    func playerDidFinishPlaying(note:NSNotification){
        dismissViewControllerAnimated(true, completion: nil)
        /*let storyboard = UIStoryboard(name: "Record", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Record") as UIViewController
        presentViewController(vc, animated: true, completion: nil)*/
        
        dispatch_async(dispatch_get_main_queue(),{
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    /*
     private func uploadWithData(data: NSData, forKey key: String) {
        let localContent = manager.localContentWithData(data, key: key)
        uploadLocalContent(localContent)
    }*/
}







