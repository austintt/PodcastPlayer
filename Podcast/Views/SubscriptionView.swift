//
//  ViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class SubscriptionView: UITableViewController {

    var podcasts = [Podcast]()
    let db = DatabaseController<Podcast>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        getSubscriptionsFromDB()
    }
    
    func getSubscriptionsFromDB() {
        let predicate = NSPredicate(format: "isSubscribed = %@", true as CVarArg)
        let results = db.query(predicate: predicate)
        
        for result in results {
            podcasts.append(result)
        }
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }

    // MARK: Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "podcastSubscriptionCell", for: indexPath) as! PodcastCell
        let podcast = podcasts[indexPath.row]
        
        cell.nameLabel.text = podcast.name
        cell.artistLabel.text = podcast.artist
        cell.artworkView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = podcasts[indexPath.row]
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "PodcastDetailViewController") as! PodcastDetailViewController
        controller.podcast = podcast
        navigationController!.pushViewController(controller, animated: true)
    }

    // MARK: DEBUG
    
    
    @IBAction func refreshTableView(_ sender: Any) {
        podcasts.removeAll()
        getSubscriptionsFromDB()
    }
    
    @IBAction func wipeDatabase(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            podcasts.removeAll()
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
            print("Realm database deleted.")
        }
    }
}

