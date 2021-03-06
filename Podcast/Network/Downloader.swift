//
//  Downloader.swift
//  Podcast
//
//  Created by Austin Tooley on 4/15/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit
import Alamofire

class Downloader {
    let db = DatabaseController<Episode>()
    
    func getAndSaveEpisode(_ episode: Episode, completionHandlerForSaveEpisode: @escaping (_ error: NSError?) -> Void) {
        if let episodeURL = episode.fileURL.toURL() {
            let audioFileName = String(episodeURL.lastPathComponent) as NSString
            
            let pathExtension = audioFileName.pathExtension
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                documentsURL.appendPathComponent("\(episode.generateFileName()).\(pathExtension)")
                return (documentsURL, [.removePreviousFile])
            }
            
            Alamofire.download(episode.fileURL, to: destination).response { response in
                if response.destinationURL != nil {
                    print(response.destinationURL!)
                    
                    // Update our episode
                    episode.isDownloaded = true
                    self.db.save(episode.detatch())
                    completionHandlerForSaveEpisode(nil)
                }
            }
        }
    }
}
