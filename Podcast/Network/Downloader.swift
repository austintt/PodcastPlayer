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
    
    func getAndSaveEpisode(_ episode: Episode) {
        //audioUrl should be of type URL
        if let episodeURL = episode.fileURL.toURL() {
            let audioFileName = String(episodeURL.lastPathComponent) as NSString
            
            //path extension will consist of the type of file it is, m4a or mp4
            let pathExtension = audioFileName.pathExtension
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                // the name of the file here I kept is yourFileName with appended extension
                documentsURL.appendPathComponent("\(episode.id).\(pathExtension)")
                return (documentsURL, [.removePreviousFile])
            }
            
            Alamofire.download(episode.fileURL, to: destination).response { response in
                if response.destinationURL != nil {
                    print(response.destinationURL!)
                }
            }
        }
    }
}
