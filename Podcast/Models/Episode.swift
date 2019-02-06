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
    @objc dynamic var showNotes: String = ""
    @objc dynamic var pubDate: Date = Date()
    @objc dynamic var fileExtension: String = ""
    @objc dynamic var playPosition: Double = 0
    @objc dynamic var hasBeenPlayed: Bool = false
    @objc dynamic var isDownloaded: Bool = false
    @objc dynamic var secondsSkipped: Double = 0.0
    @objc dynamic var podcastArtUrl = ""
    @objc dynamic var duration: Double = 0
    @objc dynamic var id = UUID().uuidString
    
    convenience init(item: RSSFeedItem, podcast: Podcast) {
        self.init()
        title = item.title ?? ""
        link = item.link ?? ""
        subtitle = item.iTunes?.iTunesSubtitle ?? ""
        summary = item.iTunes?.iTunesSummary ?? ""
        pubDate = item.pubDate ?? Date()
        fileURL = item.enclosure?.attributes?.url ?? ""
        showNotes = item.content?.contentEncoded ?? ""
        podcastName = podcast.name
        podcastID = podcast.id
        playPosition = 0
        hasBeenPlayed = false
        podcastArtUrl = podcast.artworkUrl
        duration = item.iTunes?.iTunesDuration ?? 0
        
        if let fileType = fileURL.toURL()?.pathExtension {
            fileExtension = fileType
        }
    }
    
//    override init(episode: Episode) {
//        podcastName= episode.podcastName
//        podcastID = ""
//        title = ""
//        link = ""
//        fileURL = ""
//        subtitle = ""
//        summary = ""
//        pubDate = Date()
//        fileExtension = ""
//        playPosition = 0
//        hasBeenPlayed = false
//        isDownloaded = false
//        id = UUID().uuidString
//    }
    
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
    
    func detatch() -> Episode {
        return Episode(value: self)
    }
    
    func generateFileName() -> String {
        // Maybe we'll switch back to this, but I'd rather trust our own UUIDs than naming schemes from 3rd party
//        return "\(podcastName.replacingOccurrences(of: " ", with: "_"))-\(title.replacingOccurrences(of: " ", with: "_"))"
        return id
    }
    
    // TODO: Being able to verify if an episode has been downloaded is great, but the epiosde object should also keep track of this state.
    // When displaying whether or not an episode is downloaded in a long list of episodes, this is not optimal.
    func checkIfDownloaded() -> Bool {
        isDownloaded = false
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(generateFileName()).\(self.fileExtension)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                debugPrint("FILE AVAILABLE")
                isDownloaded = true
            } else {
                debugPrint("FILE NOT AVAILABLE")
                
                isDownloaded = false
            }
        }
        return isDownloaded
    }
    
    func deleteAudioFile() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(generateFileName()).\(self.fileExtension)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: filePath)
                isDownloaded = false
                playPosition = 0
                hasBeenPlayed = false
                debugPrint("Deleted file")
            } catch let error as Error {
                debugPrint("Error deleting file: \(error.localizedDescription)")
            }
        }
    }
}
