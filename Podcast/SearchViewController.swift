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
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        
        let podcast = searchResults[indexPath.row]
        cell.textLabel!.text = podcast.name
        return cell
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        RequestManager.sharedInstance().getSearch(term: searchText) { (result, error) in
            
            if let error = error {
                print("ERROR: \(error)")
            } else {
                if let podcasts = result {
                    print("YAY: \(result)")
                    self.searchResults = podcasts
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tableView.reloadData()
    }
}
