//
//  MiniBarPlayerViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 6/16/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class MiniBarPlayerViewController: UIViewController {

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var podcastLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var episode: Episode?
    let playerPresentationViewController = PlayerPresentationViewController()
    let pauseImage: UIImage = #imageLiteral(resourceName: "pause").withRenderingMode(.alwaysTemplate)
    let playImage: UIImage = #imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        registerForNotifications()
    }
    
    func setUpView() {
        self.view.layer.cornerRadius = Constants.shared.cornerRadius
        artImageView.roundedCorners()
        playPauseButton.imageView?.tintColor = Constants.shared.purple
        podcastLabel.text = ""
        titleLabel.text = ""
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayerInfo(_:)), name: .audioPlayerWillStartPlaying, object: AudioPlayer.shared)
    }
    
    fileprivate func setArtwork() {
        if let episode = self.episode {
            artImageView.sd_imageTransition = .fade
            artImageView.sd_setImage(with: URL(string: episode.podcastArtUrl))
        
            // Gesture to open player
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            artImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc func updatePlayerInfo(_ notification: Notification) {
        episode = notification.userInfo![AudioPlayer.shared.AudioPlayerEpisodeUserInfoKey]! as! Episode
        
        // Get artwork from podcast
        setArtwork()
        
        podcastLabel.text = episode?.podcastName
        titleLabel.text = episode?.title
        titleLabel.sizeToFit()
        
        playPauseButton.setTitle("Pause", for: .normal)
        playPauseButton.setImage(pauseImage, for: .normal)
    }
    
    @IBAction func togglePlayState(_ sender: Any?) {
        if AudioPlayer.shared.isPlaying() {
            AudioPlayer.shared.pause()
            playPauseButton.setImage(playImage, for: .normal)
        } else {
            AudioPlayer.shared.play()
            playPauseButton.setImage(pauseImage, for: .normal)
        }
    }
    
    @objc private func imageTapped(_ sender: AnyObject) {
        print("Minibar art tapped")
        openBigPlayer()
//        performSegue(withIdentifier: "playerDetailSegue", sender: self)
    }
    
    
//    // MARK: Transition
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "playerDetailSegue", let destiniation = segue.destination as? PlayerViewController, let episode = self.episode {
//            destiniation.episode = episode
////            let miniBarFrame = self.view.frame
//            playerPresentationViewController.miniPlayerFrame = self.view.frame
//        }
//    }
    
    private func openBigPlayer() {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "PlayerSwipeViewController") as? PlayerSwipeViewController, let episode = self.episode {
            controller.episode = episode
            self.present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: Transition Extensions

///*****
// * Transition Delegates refer a view controller to where it can find a transition. Everytime an object asks `ViewController`
// * which transition to perform, return the desired presentation controller.
// *****/
//extension MiniBarPlayerViewController : UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return playerPresentationViewController
//    }
//
//    // TODO: Create a CardDismissalViewController
//    //    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    //        return cardDismissalViewController
//    //    }
//}
