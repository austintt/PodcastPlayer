//
//  PodcastDetailView.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastDetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var podcast: Podcast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = podcast.name
        
        coverImageView.sd_setImage(with: URL(string: podcast.artworkUrl!), placeholderImage: #imageLiteral(resourceName: "taz"))
        nameLabel.text = podcast.name
        
    }
    
    
}
