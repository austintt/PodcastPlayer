//
//  Podcast.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation

struct Podcast {
    var name: String
    var artworkUrl: String?
    var feedUrl: String?
    
    init(dictionary: [String:AnyObject]) {
        
        name = dictionary[RequestManager.JSONResponseKeys.podcastName] as! String
        artworkUrl = dictionary[RequestManager.JSONResponseKeys.artworkUrl] as? String
        feedUrl = dictionary[RequestManager.JSONResponseKeys.feedUrl] as? String
    }
    
    static func podcastsFromResults(_ results: [[String:AnyObject]]) -> [Podcast] {
        var podcasts = [Podcast]()
        
        for result in results {
            podcasts.append(Podcast(dictionary: result))
        }
        
        return podcasts
    }
}
