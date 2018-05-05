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
    
    var episode: Episode!
    var podcast: Podcast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContent()
        playEpisode()
    }
    
    func setUpContent() {
        episodeArtwork.sd_setImage(with: URL(string: podcast.artworkUrl))
        title = episode.title
        
    }
    
    func playEpisode() {
        // Download the episode if we don't have it yet
        if !episode.checkIfDownloaded() {
            let downloader = Downloader()
            downloader.getAndSaveEpisode(episode) { (error) in
                if let error = error {
                    debugPrint("Error downloading \(error)")
                } else {
                    AudioPlayer.shared.play(episode: self.episode)
                }
            }
        } else {
            AudioPlayer.shared.play(episode: episode)
        }
        
        
        
    }
    
    @IBAction func playPause(_ sender: Any) {
        if AudioPlayer.shared.isPlaying() {
             AudioPlayer.shared.pause()
        } else {
             AudioPlayer.shared.play(episode: nil)
        }
    }
    
    @IBAction func skipPressed(_ sender: Any) {
    }
    
    @IBAction func backPressed(_ sender: Any) {
    }
    
}
