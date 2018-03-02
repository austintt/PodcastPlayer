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
    }
    
    func setUpContent() {
        episodeArtwork.sd_setImage(with: URL(string: podcast.artworkUrl))
        title = episode.title
        
    }
    
    @IBAction func playPause(_ sender: Any) {
    }
    
    @IBAction func skipPressed(_ sender: Any) {
    }
    
    @IBAction func backPressed(_ sender: Any) {
    }
    
}
