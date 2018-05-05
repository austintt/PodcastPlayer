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
    @objc dynamic var podcastName: String = ""
    @objc dynamic var podcastID = ""
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var fileURL: String = ""
    @objc dynamic var subtitle: String = ""
    @objc dynamic var summary: String = ""
    @objc dynamic var pubDate: Date = Date()
    @objc dynamic var fileExtension: String = ""
    @objc dynamic var playPosition: Int = 0
    @objc dynamic var hasBeenPlayed: Bool = false
    @objc dynamic var id = UUID().uuidString
    
    convenience init(item: RSSFeedItem, podcast: Podcast) {
        self.init()
        title = item.title ?? ""
        link = item.link ?? ""
        subtitle = item.iTunes?.iTunesSubtitle ?? ""
        summary = item.iTunes?.iTunesSummary ?? ""
        pubDate = item.pubDate ?? Date()
        fileURL = item.enclosure?.attributes?.url ?? ""
        podcastName = podcast.name
        podcastID = podcast.id
        playPosition = 0
        hasBeenPlayed = false
        
        if let fileType = fileURL.toURL()?.pathExtension {
            fileExtension = fileType
        }
    }
    
    static func episodeFromFeed(feed: RSSFeed, podcast: Podcast) -> [Episode]{
        var episodes = [Episode]()
        
        for item in feed.items! {
            // For those shows that for some reason place the name of the
            // podcast at the start of the episode title
            item.title = item.title!.replacingOccurrences(of: "\(feed.title!): ", with: "")
            item.title = item.title!.replacingOccurrences(of: "\(feed.title!) ", with: "")
            item.title = item.title!.replacingOccurrences(of: feed.title!, with: "")
            episodes.append(Episode(item: item, podcast: podcast))
            
        }
        return episodes
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func generateFileName() -> String {
        return "\(podcastName)-\(title)"
    }
    
    func checkIfDownloaded() -> Bool {
        var isDownloaded = false
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(generateFileName()).\(self.fileExtension)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                isDownloaded = true
            } else {
                print("FILE NOT AVAILABLE")
                isDownloaded = false
            }
        }
        return isDownloaded
    }
}
