import UIKit
import MediaPlayer
import AVKit
import AVFoundation


class VideoViewController: UIViewController,AVAudioPlayerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func playVideo2(sender: UIButton) {
        video1("https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4");
    }
 
    
    func video1(url:String){
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

