//
//  SubscriptionArtCell.swift
//  Podcast
//
//  Created by Austin Tooley on 6/12/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class SubscriptionArtCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    private var shadowLayer: CAShapeLayer?
    private var cornerRadius: CGFloat = Constants.shared.cornerRadius
    private var fillColor: UIColor = .green
    var hasBeenConstructed = false
    
    func updateContent(podcast: Podcast) {
        imageView.sd_imageTransition = .fade
        imageView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        titleLabel.text = podcast.name
        subtitleLabel.text = podcast.artist
    }
    
    func constructCell() {
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        hasBeenConstructed = true
    }
    
    private func createShadow() {
        if !hasBeenConstructed {
            
        }
    }
}
