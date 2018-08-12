//
//  RemoteCommandCenter+AudioPlayer.swift
//  Podcast
//
//  Created by Austin Tooley on 8/12/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation
import MediaPlayer
import SDWebImage

extension AudioPlayer {
    func registerForRemoteCommands() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Set up buttons
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [30]
        commandCenter.skipBackwardCommand.preferredIntervals = [30]
        
        
        if let player = self.player {
            // Add handler for Play Command
            commandCenter.playCommand.addTarget { [unowned self] event in
                if !player.isPlaying {
                    self.play()
                    return .success
                }
                return .commandFailed
            }
            
            // Add handler for Pause Command
            commandCenter.pauseCommand.addTarget { [unowned self] event in
                if player.isPlaying {
                    self.pause()
                    return .success
                }
            return .commandFailed
            }
            
            // Add handler for rewind
            commandCenter.skipBackwardCommand.addTarget { [unowned self] event in
                self.back(by: Constants.shared.skipDuration)
                return .success
            }
            
            // Add handler for skip
            commandCenter.skipForwardCommand.addTarget { [unowned self] event in
                self.forward(by: Constants.shared.skipDuration)
                return .success
            }
        }
        
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        
        
        
        
        if let player = player, let episode = episode {
            
            // image
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: episode.podcastArtUrl)) { (image, error, type, url) in
                if let image = imageView.image {
                    nowPlayingInfo[MPMediaItemPropertyArtwork] =
                        MPMediaItemArtwork(boundsSize: image.size) { size in
                            return image
                    }
                }
            }
            
            // meta data
            nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
            nowPlayingInfo[MPMediaItemPropertyArtist] = episode.podcastName
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = episode.duration
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        }
        
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
