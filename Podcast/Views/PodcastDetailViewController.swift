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
import RealmSwift

class PodcastDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var podcast: Podcast!
    var reconciliationMap = [String:Episode]()
    let db = DatabaseController<Podcast>()
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // See if we are already subscribed
        checkIfSubscribed()
        
        setUpContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        parseEpisodesFromFeed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        if self.podcast.isSubscribed {
//            db.save(podcast)
//        }
    }
    
    private func setUpContent() {
        coverImageView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        self.title = podcast.name
        artistLabel.text = podcast.artist
        setSubscriptionButtonText()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func checkIfSubscribed() {
        // Query db for podcast by feedURL
        let predicate = NSPredicate(format: "feedUrl = %@", podcast.feedUrl)
        let results = db.query(predicate: predicate)
        
        if let subscribedPodcast = results.first {
            // Detatch podcast
            podcast = subscribedPodcast.detatch()
            
            // Convert episodes to array (easier to sort later)
            episodes = Array(podcast.episodes)
            episodes.sort { ($0.pubDate) > ($1.pubDate) }
            
            // Create map used to reconcile episodes pulled in from feed
            reconciliationMap = podcast.createReconciliationMap()
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
    
    private func parseEpisodesFromFeed() {
        if let url = URL(string: podcast.feedUrl) {
            if let parser = FeedParser(URL: url) {
                // Parse asynchronously, not to block the UI.
                parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                    
                    if let feed = result.rssFeed {
                        self.podcast.descriptionText = feed.description!
                        
                        // Reconcile episodes from feed with those saved
                        self.reoncileEpisodes(Episode.episodeFromFeed(feed: feed))
                        
                        // Save new episodes to podcast
                        if self.podcast.isSubscribed {
                            self.db.save(self.podcast)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.descriptionTextView.text = self.podcast.descriptionText
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func reoncileEpisodes(_ feedEpisodes: [Episode]) {
        for episode in feedEpisodes {
            if reconciliationMap[episode.link] == nil {
                podcast.episodes.append(episode)
                episodes.append(episode)
            }
        }
        episodes.sort { ($0.pubDate) > ($1.pubDate) }
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
