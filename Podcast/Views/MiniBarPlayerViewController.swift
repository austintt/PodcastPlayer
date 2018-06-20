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
    
    let db = DatabaseController<Podcast>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        registerForNotifications()
    }
    
    func setUpView() {
        view.layer.addBorder(edge: .top, color: Constants.shared.purple, thickness: 1)
        artImageView.roundedCorners()
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayerInfo(_:)), name: .audioPlayerWillStartPlaying, object: AudioPlayer.shared)
    }
    
    fileprivate func setArtwork(_ episode: Episode) {
        if !episode.podcastArtUrl.isEmpty {
            artImageView.sd_imageTransition = .fade
            artImageView.sd_setImage(with: URL(string: episode.podcastArtUrl))
        }
    }
    
    @objc func updatePlayerInfo(_ notification: Notification) {
        let episode = notification.userInfo![AudioPlayer.shared.AudioPlayerEpisodeUserInfoKey]! as! Episode
        
        // Get artwork from podcast
        setArtwork(episode)
        
        playPauseButton.setTitle("Pause", for: .normal)

    }
    
    @IBAction func togglePlayState(_ sender: Any?) {
        if AudioPlayer.shared.isPlaying() {
            AudioPlayer.shared.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            AudioPlayer.shared.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
}
