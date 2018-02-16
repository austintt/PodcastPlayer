//
//  PodcastDetailView.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit
import SDWebImage
import FeedKit

class PodcastDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    let db = DatabaseController<Podcast>()
    var podcast: Podcast!
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // See if we are already subscribed
        checkIfSubscribed()
        
        setUpContent()
        
        getEpisodes()
    }
    
    func setUpContent() {
        coverImageView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        self.title = podcast.name
        artistLabel.text = podcast.artist
        setSubscriptionButtonText()
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func getEpisodes() {
        if let url = URL(string: podcast.feedUrl) {
            if let parser = FeedParser(URL: url) {
                // Parse asynchronously, not to block the UI.
                parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
     
                    if let feed = result.rssFeed {
                        
                        self.episodes = Episode.episodeFromFeed(feed: feed)
                        print(self.episodes.count)
                    }
                    
                    DispatchQueue.main.async {
//                        self.descriptionTextView.text = feed.description
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
        
    }
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        
        let episode = episodes[indexPath.row]
        cell.textLabel!.text = episode.title
        return cell
    }
    
}
