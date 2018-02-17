//
//  Episode.swift
//  Podcast
//
//  Created by Austin Tooley on 2/15/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation
import RealmSwift
import FeedKit

class Episode: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var subtitle: String = ""
    @objc dynamic var summary: String = ""
    @objc dynamic var pubDate: Date = Date()
    @objc dynamic var playPosition: Int = 0
    @objc dynamic var hasBeenPlayed: Bool = false
    @objc dynamic var id = UUID().uuidString
    
    convenience init(item: RSSFeedItem) {
        self.init()
        title = item.title ?? ""
        link = item.link ?? ""
        subtitle = item.iTunes?.iTunesSubtitle ?? ""
        summary = item.iTunes?.iTunesSummary ?? ""
        pubDate = item.pubDate ?? Date()
        playPosition = 0
        hasBeenPlayed = false
    }
    
    static func episodeFromFeed(feed: RSSFeed) -> [Episode]{
        var episodes = [Episode]()
        
        for item in feed.items! {
            episodes.append(Episode(item: item))
        }
        return episodes
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
