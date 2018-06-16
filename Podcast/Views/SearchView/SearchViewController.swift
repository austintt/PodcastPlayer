//
//  SearchViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchView: UISearchBar!
    
    var searchActive : Bool = false
    var filtered = [String]()
    var searchResults = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
    }
    
    // MARK: Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! PodcastCell
        
        let podcast = searchResults[indexPath.row]
//        cell.textLabel!.text = podcast.name
        cell.nameLabel.text = podcast.name
        cell.artistLabel.text = podcast.artist
        cell.artworkView.sd_imageTransition = .fade
        cell.artworkView.sd_setImage(with: URL(string: podcast.artworkUrl), placeholderImage: #imageLiteral(resourceName: "taz"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = searchResults[indexPath.row]
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "PodcastDetailViewController") as! PodcastDetailViewController
        controller.podcast = podcast
        navigationController!.pushViewController(controller, animated: true)
    }
    
    
    // MARK: Search Bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    @objc fileprivate func fetchResults(_ searchBar: UISearchBar) {
        
        guard let query = searchBar.text else {
            return
        }
        
        RequestManager.sharedInstance().getSearch(term: query) { (result, error) in
            
            if let error = error {
                print("ERROR: \(error)")
            } else {
                if let podcasts = result {
                    
                    // Clear table
                    self.searchResults = [Podcast]()
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                    }
                
                    // Update Table
                    self.searchResults = podcasts
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Cancel previous operation
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchResults(_:)), object: self.searchView)
        
        // Delay until done typing
        self.perform(#selector(self.fetchResults(_:)), with: self.searchView, afterDelay: 0.4)
    }
}
