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
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("\(newEpisode.generateFileName()).\(newEpisode.fileExtension)")
            
            let url = documentsURL
            
            do {
                audio = try AVAudioPlayer(contentsOf: url)
                guard let audio = audio else {return}
                audio.prepareToPlay()
                audio.play()
                debugPrint("Play")
            } catch {
                debugPrint("Couln't load the file :(")
            }
        } else {
            debugPrint("Resume")
            audio?.play()
        }
    }
    
    func pause() {
        debugPrint("Pause")
        audio?.pause()
    }
    
    func forward() {
    }
    
    func back() {
        
    }
    
    func isPlaying() -> Bool {
        if let audioState = audio?.isPlaying {
            return audioState
        }
        return false
    }
    
    
}
