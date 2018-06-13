//
//  PodcastCollectionCell.swift
//  Podcast
//
//  Created by Austin Tooley on 6/12/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class SubscriptionPillCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    var hasBeenConstructed = false
    
    func updateContent(podcast: Podcast) {
        imageView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        titleLabel.text = podcast.name
        subtitleLabel.text = podcast.artist
    }
    
    func constructCell() {
        self.layer.cornerRadius = 8
        self.backgroundColor = .blue
        hasBeenConstructed = true
    }
    
    func changeColor() {
        
    }
}
