//
//  EpisodeDetailViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 2/20/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    
    @IBOutlet weak var episodeArtwork: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var episode: Episode!
    var podcast: Podcast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContent()
        if !AudioPlayer.shared.isPlaying() || AudioPlayer.shared.episode?.id != episode.id {
            AudioPlayer.shared.stop()
            playEpisode()
        }
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
    }
    
    @IBAction func backPressed(_ sender: Any) {
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
    
}
