//
//  TypingThrottler.swift
//  Podcast
//
//  Created by Austin Tooley on 4/14/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

final class TypingThrottler {
    typealias Handler = (String) -> Void
    let interval: TimeInterval
    let handler: Handler
    private var workItem: DispatchWorkItem?
    
    // Handler will only be called after the user has stopped typing for interval of seconds
    init(interval: TimeInterval = 0.4, handler: @escaping Handler) {
        self.interval = interval
        self.handler = handler
    }
    
    // Call this every time the text changes in a text field
    func handleTyping(cid text: String) {
        workItem?.cancel()
        
        workItem = DispatchWorkItem { [weak self] in
            self?.handler(text)
        }
        
        if let workItem = self.workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: workItem)
        }
    }
}

//        let throttler = TypingThrottler(interval: 0.4) { (text) in
//            RequestManager.sharedInstance().getSearch(term: text) { (result, error) in
//
//                if let error = error {
//                    print("ERROR: \(error)")
//                } else {
//                    if let podcasts = result {
//
//                        // Clear table
//                        self.searchResults = [Podcast]()
//                        performUIUpdatesOnMain {
//                            self.tableView.reloadData()
//                        }
//
//                        // Update Table
//                        self.searchResults = podcasts
//                        performUIUpdatesOnMain {
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//
//        throttler.handleTyping(with: searchText)
