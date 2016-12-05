// Created by: Kee Sern Chua

import UIKit
import MediaPlayer
import AVKit
import AVFoundation


class VideoViewController: UIViewController,AVAudioPlayerDelegate {

    @IBOutlet weak var sampleVideo: UIButton!
    @IBOutlet weak var playVideo1: UIButton!
    @IBOutlet weak var feedback: UIButton!
    @IBOutlet weak var Back: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        sampleVideo.layer.cornerRadius = 4
        playVideo1.layer.cornerRadius = 4

    }

    @IBAction func sampleVideo(sender: UIButton) {
        playSampleVideo("https://s3.amazonaws.com/aepios-userfiles-mobilehub-1099679197/public/SampleVideo.mp4")
        
    }
    @IBAction func playVideo1(sender: UIButton) {
        video("https://s3.amazonaws.com/aepios-userfiles-mobilehub-1099679197/public/Lesson1Part1.mp4");
        

    }
    @IBAction func feedback(sender: UIButton) {
        let storyboard = UIStoryboard(name: "UserFiles", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("UserFiles")
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    
    func video(url:String){
        let videoURL = NSURL(string: url)
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
 
    func playSampleVideo(url:String){
        let videoURL = NSURL(string: url)
        let player = AVPlayer(URL: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sampleVideoPlayerDidFinishPlaying:",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: playerViewController.player!.currentItem)
        
    }
    
    func sampleVideoPlayerDidFinishPlaying(note:NSNotification){
        print("finished")
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func playerDidFinishPlaying(note:NSNotification){
        print("finished")
        dismissViewControllerAnimated(true, completion: nil)
        let storyboard = UIStoryboard(name: "Record", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Record") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func record(){
        print("Recording")
    }

 
    
}

