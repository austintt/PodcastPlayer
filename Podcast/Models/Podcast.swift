//
//  Podcast.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation
import RealmSwift

class Podcast: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var artworkUrl: String = ""
    @objc dynamic var feedUrl: String = ""
    @objc dynamic var artworkImage: NSData = NSData()
    @objc dynamic var isSubscribed: Bool = false
    @objc dynamic var id = UUID().uuidString
    
    convenience init(dictionary: [String:AnyObject]) {
        self.init()
        name = dictionary[RequestManager.JSONResponseKeys.podcastName] as? String ?? ""
        artworkUrl = dictionary[RequestManager.JSONResponseKeys.artworkUrl] as? String ?? ""
        feedUrl = dictionary[RequestManager.JSONResponseKeys.feedUrl] as? String ?? ""
        artworkImage = NSData()
    }
    
    static func podcastsFromResults(_ results: [[String:AnyObject]]) -> [Podcast] {
        var podcasts = [Podcast]()
        
        for result in results {
            podcasts.append(Podcast(dictionary: result))
        }
        
        return podcasts
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
