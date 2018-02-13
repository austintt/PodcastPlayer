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
    
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    let db = DatabaseController<Podcast>()
    
    var podcast: Podcast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // See if we are already subscribed
//        checkIfSubscribed()
        
        setUpContent()
    }
    
    func setUpContent() {
        self.title = podcast.name
        coverImageView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        nameLabel.text = podcast.name
        
//        toggleSubscription()
    }
    
    func checkIfSubscribed() {
        let predicate = NSPredicate(format: "feedUrl = %@", podcast.feedUrl)
        let results = db.query(predicate: predicate)
        
        if let subscribedPodcast = results.first as? Podcast {
            podcast = subscribedPodcast
        }
    }
    
    func toggleSubscription() {
        if podcast.isSubscribed {
            subscriptionButton.titleLabel?.text = "Unsubscribe"
            podcast.isSubscribed = false
            // TODO Delete from db
            db.save(podcast)
        } else {
            subscriptionButton.titleLabel?.text = "Subscribe"
            podcast.isSubscribed = true
            db.save(podcast)
        }
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        toggleSubscription()
    }
    
}
