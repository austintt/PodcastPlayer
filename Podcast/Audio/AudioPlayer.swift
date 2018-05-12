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
    var episode: Episode?
    
    func setEpisode(_ episode: Episode) {
        self.episode = episode
    }
    
    func play(_ newEpisode: Episode? = nil) {
        // Hanlde a new episode if we have one
        if let newEpisode = newEpisode {
            setEpisode(newEpisode)
            
            // Grab file
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("\(newEpisode.generateFileName()).\(newEpisode.fileExtension)")
            
            let url = documentsURL
            
            // Play
            do {
                audio = try AVAudioPlayer(contentsOf: url)
                guard let audio = audio else {return}
                setupPlayer()
                audio.prepareToPlay()
            } catch {
                debugPrint("Couln't load the file :(")
            }
        }
        
        // Grab file
        if let currentEp = episode {
            guard let audio = self.audio else {return}
            
            // Play
            audio.play()
            debugPrint("Play")
        }
    }
    
    func pause() {
        guard let audio = self.audio else {return}
        
        debugPrint("Pause")
        audio.pause()
    
    }
    
    func forward(by: Double) {
        debugPrint("Forward")
        audio?.seek(by)
    }
    
    func back(by: Double) {
        debugPrint("Back")
        audio?.seek(by * -1)
    }
    
    func stop() {
        guard let audio = self.audio else {return}
        
        audio.stop()
    }
    
    func isPlaying() -> Bool {
        if let audioState = audio?.isPlaying {
            return audioState
        }
        return false
    }
    
    func setupPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeSpokenAudio, options: [.allowAirPlay, .allowBluetooth])
            debugPrint("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            debugPrint("Session is Active")
        } catch {
            debugPrint("Error setting up audio session \(error)")
        }
    }
    
}
