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
        checkIfSubscribed()
        
        setUpContent()
    }
    
    func setUpContent() {
        self.title = podcast.name
        coverImageView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        nameLabel.text = podcast.name
        setSubscriptionButtonText()
    }
    
    private func checkIfSubscribed() {
        let predicate = NSPredicate(format: "feedUrl = %@", podcast.feedUrl)
        let results = db.query(predicate: predicate)
        
        if let subscribedPodcast = results.first {
            podcast = Podcast(value: subscribedPodcast)
            
        }
    }
    
    private func toggleSubscription() {
        if podcast.isSubscribed {
            
            podcast.isSubscribed = false
            setSubscriptionButtonText()
            // TODO Delete from db
            db.save(podcast)
        } else {
            podcast.isSubscribed = true
            setSubscriptionButtonText()
            db.save(podcast)
        }
    }
    
    private func setSubscriptionButtonText() {
        if podcast.isSubscribed {
            subscriptionButton.setTitle("Unsubscribe", for: .normal)
        } else {
            subscriptionButton.setTitle("Subscribe", for: .normal)
        }
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        toggleSubscription()
    }
    
}
