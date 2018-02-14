//
//  ViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit
import RealmSwift

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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return podcasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "podcastSubscriptionCell", for: indexPath)
        
        let podcast = podcasts[indexPath.row]
        cell.textLabel!.text = podcast.name
        return cell
    }

    
    @IBAction func wipeDatabase(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            print("Realm database deleted.")
        }
    }
}

