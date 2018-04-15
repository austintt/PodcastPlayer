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
        
        configureView()
        
        setUpContent()
        
        // See if we are already subscribed
        checkIfSubscribed()
        
        parseEpisodesFromFeed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        tableView.reloadData()
    }
    
    // MARK: Set up view
    
    private func setUpContent() {
        tableView.delegate = self
        tableView.dataSource = self
        
        self.coverImageView.sd_setImage(with: URL(string: self.podcast.artworkUrl))
        self.title = self.podcast.name
        self.artistLabel.text = self.podcast.artist
        self.setSubscriptionButtonText()
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
            sortEpisodes(ascending: false)
            tableView.reloadData()
            
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
        let xmlQueue = DispatchQueue(label: "com.tooley.podcast", attributes: DispatchQueue.Attributes.concurrent)
        let group = DispatchGroup()
        
        // Fetch feed asynchronously
        xmlQueue.async(group: group) {
            if let url = URL(string: self.podcast.feedUrl) {
                if let parser = FeedParser(URL: url) {
                    let result = parser.parse()
                    if let feed = result.rssFeed {
                        self.podcast.descriptionText = feed.description!

                        // Reconcile episodes from feed with those saved
                        self.reoncileEpisodes(Episode.episodeFromFeed(feed: feed, podcast: self.podcast))

                        // Save new episodes to podcast
                        if self.podcast.isSubscribed {
                            self.db.save(self.podcast)
                        }
                    }
                }
            }
        }

        // When done, update the UI
        group.notify(queue: xmlQueue) {
            performUIUpdatesOnMain {
                self.descriptionTextView.text = self.podcast.descriptionText
                self.tableView.reloadData()
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
        sortEpisodes(ascending: false)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "EpisodeDetailViewController") as! EpisodeDetailViewController
        controller.episode = episode
        controller.podcast = podcast // TODO: Clean this up
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func sortEpisodes(ascending: Bool) {
        if ascending {
            episodes.sort { ($0.pubDate) < ($1.pubDate) }
        } else {
            episodes.sort { ($0.pubDate) > ($1.pubDate) }
        }
    }
}
