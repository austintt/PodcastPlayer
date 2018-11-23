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
    private var shadowLayer: CAShapeLayer?
    private var cornerRadius: CGFloat = 8.0
    private var fillColor: UIColor = .green
    var hasBeenConstructed = false
    
    func updateContent(podcast: Podcast) {
        imageView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        titleLabel.text = podcast.name
        subtitleLabel.text = podcast.artist
    }
    
    func constructCell() {
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = Constants.shared.purple
        createShadow()
        hasBeenConstructed = true
    }
    
    private func createShadow() {
        if !hasBeenConstructed {
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOpacity = 1
            imageView.layer.shadowOffset = CGSize.zero
            imageView.layer.shadowRadius = 10
            imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
        }
    }
    
    func changeColor() {
        
    }
}
