//
//  AudioPlayer.swift
//  Podcast
//
//  Created by Austin Tooley on 5/5/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import AVFoundation

class AudioPlayer {
    
    static let shared = AudioPlayer()
    var audio: AVAudioPlayer?
    
    func play(episode: Episode?) {
        if let newEpisode = episode {
            if let path = Bundle.main.path(forResource: newEpisode.generateFileName(), ofType: newEpisode.fileExtension) {
                let url = URL(fileURLWithPath: path)
                
                do {
                    audio = try AVAudioPlayer(contentsOf: url)
                    audio?.play()
                } catch {
                    debugPrint("Couln't load the file :(")
                }
            }
        }
    }
    
    func pause() {
        audio?.pause()
    }
    
    func forward() {
        
    }
    
    func back() {
        
    }
    
    
}
