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

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var episodeArtwork: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressView: UISlider!
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var timeProgressLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var secondsSkippedLabel: UILabel!
    @IBOutlet weak var podcastNameLabel: UILabel!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var episode: Episode!
    let pauseImage: UIImage = #imageLiteral(resourceName: "pause").withRenderingMode(.alwaysTemplate)
    let playImage: UIImage = #imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContent()
        setUpStyle()
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
        episodeArtwork.sd_setImage(with: URL(string: episode.podcastArtUrl))
        episodeTitleLabel.text = episode.title
        podcastNameLabel.text = episode.podcastName
        secondsSkippedLabel.text = ""
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        
        // Player buttons
        playPauseButton.setImage(pauseImage, for: .normal)
        
        // Hide mini player
    }
    
    func setUpStyle() {
        
        // Art
        episodeArtwork.layer.cornerRadius = Constants.shared.cornerRadius
        episodeArtwork.clipsToBounds = true
        episodeArtwork.layer.masksToBounds = true
        
        // Buttons
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.tintColor = Constants.shared.purple
        playPauseButton.imageView?.tintColor = UIColor.purple
        
        // Information
        activityIndicator.color = Constants.shared.purple
        
        // shadow
        
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
            playPauseButton.setImage(playImage, for: .normal)
        } else {
             AudioPlayer.shared.play()
            playPauseButton.setImage(pauseImage, for: .normal)
        }
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        AudioPlayer.shared.forward(by: Constants.shared.skipDuration)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        AudioPlayer.shared.back(by: Constants.shared.skipDuration)
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
        let skippedSeconds = notification.userInfo![AudioPlayer.shared.AudioPlayerSecondsSkippedKey]! as! Double
        
        performUIUpdatesOnMain {
            self.timeProgressLabel.text = "\(secondsElapsed.rounded().timeStringWithHours())"
            self.timeRemainingLabel.text = "-\(secondsRemaining.rounded().timeStringWithHours())"
        }
        
        if skippedSeconds > 0 {
            if skippedSeconds < 60 {
                performUIUpdatesOnMain {
                    self.secondsSkippedLabel.text = "\(String(format: "%.2f", skippedSeconds)) seconds skipped"
                }
            } else {
                performUIUpdatesOnMain {
                    self.secondsSkippedLabel.text = "\(skippedSeconds.timeString()) skipped"
                }
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
