//
//  AudioPlayer.swift
//  Podcast
//
//  Created by Austin Tooley on 5/5/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation
import AVFoundation

extension Notification.Name {
    static let audioPlayerWillStartPlaying = Notification.Name("audioPlayerWillStartPlaying")
    static let audioPlayerDidStartLoading = Notification.Name("audioPlayerDidStartLoading")
    static let audioPlayerDidStartPlaying = Notification.Name("audioPlayerDidStartPlaying")
    static let audioPlayerDidPause = Notification.Name("audioPlayerDidPause")
    static let audioPlayerPlaybackTimeChanged = Notification.Name("audioPlayerPlaybackTimeChanged")
}

class AudioPlayer {
    
    static let shared = AudioPlayer()
    let db = DatabaseController<Episode>()
    var player: AVAudioPlayer? 
    var episode: Episode?
    var timer: Timer?
    var decibelThreshold: Float = -40
    var samplingRate = 0.05
    var secondsOfIncreasedPlayback = 0.0
    let AudioPlayerEpisodeUserInfoKey = "AudioPlayerEpisodeUserInfoKey"
    let AudioPlayerSecondsElapsedUserInfoKey = "AudioPlayerSecondsElapsedUserInfoKey"
    let AudioPlayerSecondsRemainingUserInfoKey = "AudioPlayerSecondsRemainingUserInfoKey"
    
    func setEpisode(_ episode: Episode) {
        
        self.episode = episode.detatch()
    }
    
    // Hanlde a new episode if we have one
    func play(_ newEpisode: Episode) {
        
        setEpisode(newEpisode)
        
        // Grab file
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent("\(newEpisode.generateFileName()).\(newEpisode.fileExtension)")
        
        let url = documentsURL
        
        // Get ready to play
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let audio = player else {return}
            setupPlayer()
            audio.prepareToPlay()

        } catch {
            debugPrint("Couln't load the file :(")
        }
    
        play()
    }
    
    func play() {
        if let currentEp = episode {
            guard let audio = self.player else {
                debugPrint("ERROR: Trying to play but player hasn't been instantiated")
                return
            }
            
            // Play
            audio.play()
            debugPrint("Play")
            
            // Notify
            NotificationCenter.default.post(name: .audioPlayerWillStartPlaying, object: self, userInfo: [AudioPlayerEpisodeUserInfoKey: currentEp])
            
            // Timer to keep track of progress
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(udateProgress), userInfo: nil, repeats: true)
        }
    }
    
    func pause() {
        guard let audio = self.player else {return}
        
        debugPrint("Pause")
        audio.pause()
        timer?.invalidate()
    }
    
    func forward(by: Double) {
        guard let audio = self.player else {return}
        debugPrint("Forward")
        audio.seek(by)
    }
    
    func back(by: Double) {
        guard let audio = self.player else {return}
        debugPrint("Back")
        audio.seek(by * -1)
    }
    
    func stop() {
        guard let audio = self.player else {return}
        debugPrint("Stop")
        audio.stop()
        timer?.invalidate()
    }
    
    func isPlaying() -> Bool {
        if let audioState = player?.isPlaying {
            return audioState
        }
        return false
    }
    
    func setupPlayer() {
        player?.isMeteringEnabled = true
        player?.enableRate = true
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeSpokenAudio, options: [.allowAirPlay, .allowBluetooth])
            debugPrint("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            debugPrint("Session is Active")
        } catch {
            debugPrint("Error setting up audio session \(error)")
        }
    }
    
    func getProgress() -> TimeInterval? {
        if let audio = player {
            return audio.currentTime
        }
        return nil
    }
    
    @objc private func udateProgress() {
        if let audio = player, let episode = episode {
            episode.playPosition = audio.currentTime
//            self.db.save(episode)
            // Notify
            NotificationCenter.default.post(name: .audioPlayerPlaybackTimeChanged, object: self, userInfo: [
                AudioPlayerSecondsElapsedUserInfoKey: audio.timeElapsed,
                AudioPlayerSecondsRemainingUserInfoKey: audio.timeRemaining
            ])
            debugPrint("Progress: \(audio.currentTime)")
        }
    }
    
    // https://blog.breaker.audio/how-we-skip-silences-in-podcasts-with-avaudioplayer-69232b57850a
    
}
