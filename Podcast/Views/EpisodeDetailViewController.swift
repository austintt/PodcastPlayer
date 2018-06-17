//
//  EpisodeDetailViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 2/20/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let episodeDetailViewLoaded = Notification.Name("episodeDetailViewLoaded")
    static let episodeDetailViewWillDisappear = Notification.Name("episodeDetailViewWillDisappear")
}

class EpisodeDetailViewController: UIViewController {
    
    @IBOutlet weak var episodeArtwork: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressView: UISlider!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var timeProgressLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    var episode: Episode!
    var podcast: Podcast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContent()
        registerNotifications()
        
        if !AudioPlayer.shared.isPlaying() || AudioPlayer.shared.episode?.id != episode.id {
            AudioPlayer.shared.stop()
            playEpisode()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.post(name: .episodeDetailViewWillDisappear, object: self, userInfo: nil)
    }
    
    func setUpContent() {
        
        // Podcast details
        episodeArtwork.sd_setImage(with: URL(string: podcast.artworkUrl))
        title = episode.title
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.color = Constants.shared.purple
        
        // Player buttons
        playPauseButton.setTitle("Pause", for: .normal)
        
        // Hide mini player
    }
    
    
    func registerNotifications() {
        // Notify
        NotificationCenter.default.post(name: .episodeDetailViewLoaded, object: self, userInfo: nil)
        
        // Register
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerPlaybackTimeChanged(_:)), name: .audioPlayerPlaybackTimeChanged, object: AudioPlayer.shared)
    }
    
    func playEpisode() {
        // Download the episode if we don't have it yet
        if !episode.checkIfDownloaded() {
            let downloader = Downloader()
            toggleActivityIndicator()
            downloader.getAndSaveEpisode(episode) { (error) in
                if let error = error {
                    debugPrint("Error downloading \(error)")
                } else {
                    AudioPlayer.shared.play(self.episode)
                }
                self.toggleActivityIndicator()
            }
        } else {
            AudioPlayer.shared.play(self.episode)
        }
    }
    
    @IBAction func playPause(_ sender: Any) {
        if AudioPlayer.shared.isPlaying() {
            AudioPlayer.shared.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
             AudioPlayer.shared.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        AudioPlayer.shared.forward(by: 30)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        AudioPlayer.shared.back(by: 30)
    }
    
    func toggleActivityIndicator() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            playPauseButton.isHidden = false
        } else {
            playPauseButton.isHidden = true
            activityIndicator.startAnimating()
        }
    }
    
    @objc private func audioPlayerPlaybackTimeChanged(_ notification: Notification) {
        let secondsElapsed = notification.userInfo![AudioPlayer.shared.AudioPlayerSecondsElapsedUserInfoKey]! as! Double
        let secondsRemaining = notification.userInfo![AudioPlayer.shared.AudioPlayerSecondsRemainingUserInfoKey]! as! Double

        performUIUpdatesOnMain {
            self.timeProgressLabel.text = "\(secondsElapsed.rounded())"
            self.timeRemainingLabel.text = "-\(secondsRemaining.rounded())"
        }
    }
    
}
