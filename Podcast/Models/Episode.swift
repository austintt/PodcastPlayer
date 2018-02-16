//
//  Episode.swift
//  Podcast
//
//  Created by Austin Tooley on 2/15/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation
import FeedKit

class Episode {
    var title: String
    var link: String
    var subtitle: String
    var summary: String
    var pubDate: Date
    var playPosition: Int
    var hasBeenPlayed: Bool
    
    init(item: RSSFeedItem) {
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
}
