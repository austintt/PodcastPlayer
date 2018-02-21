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
    @IBOutlet weak var episodesSegmentView: UISegmentedControl!
    
    var podcast: Podcast!
    var reconciliationMap = [String:Episode]()
    let db = DatabaseController<Podcast>()
    var episodes = [Episode]()
    
    // MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // See if we are already subscribed
        checkIfSubscribed()
        configureView()
        setUpContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        parseEpisodesFromFeed()
    }

    @IBAction func subscribeButtonPressed(_ sender: Any) {
        toggleSubscription()
    }
    
    @IBAction func changeEpisodesOrder(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
        case 0:
            sortEpisodes(ascending: false)
        case 1:
            sortEpisodes(ascending: true)
        default:
            sortEpisodes(ascending: true)
            
        }
    }
    
    // MARK: Set up view
    
    private func setUpContent() {
        coverImageView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        self.title = podcast.name
        artistLabel.text = podcast.artist
        setSubscriptionButtonText()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureView() {
        
        // Subscribe button
        subscriptionButton.backgroundColor = .clear
        subscriptionButton.layer.borderWidth = 1
        subscriptionButton.layer.borderColor = Constants.shared.purple.cgColor
        subscriptionButton.layer.cornerRadius = 8
        subscriptionButton.tintColor = Constants.shared.purple
        
        // Order segment view
        episodesSegmentView.tintColor = Constants.shared.purple
        episodesSegmentView.layer.borderColor = Constants.shared.purple.cgColor
        episodesSegmentView.layer.borderWidth = 1
        episodesSegmentView.layer.cornerRadius = 0
    }
    
    // MARK: Data manipulation
    
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
    
    func sortEpisodes(ascending: Bool) {
        if ascending {
            episodes.sort { ($0.pubDate) < ($1.pubDate) }
        } else {
            episodes.sort { ($0.pubDate) > ($1.pubDate) }
        }
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
}
