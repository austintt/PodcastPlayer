//
//  AudioPlayer.swift
//  Podcast
//
//  Created by Austin Tooley on 5/5/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

extension Notification.Name {
    static let audioPlayerWillStartPlaying = Notification.Name("audioPlayerWillStartPlaying")
    static let audioPlayerDidStartLoading = Notification.Name("audioPlayerDidStartLoading")
    static let audioPlayerDidStartPlaying = Notification.Name("audioPlayerDidStartPlaying")
    static let audioPlayerDidPause = Notification.Name("audioPlayerDidPause")
    static let audioPlayerPlaybackTimeChanged = Notification.Name("audioPlayerPlaybackTimeChanged")
}

class AudioPlayer {
    
    // Player
    static let shared = AudioPlayer()
    let db = DatabaseController<Episode>()
    var player: AVAudioPlayer? 
    var episode: Episode?
    var timer: Timer?
    
    // Audio Manipulation
    var shouldSkipSilences = false
    var playerTimeObserver: Timer?
    var decibelThreshold: Float = -35
    var defaultPlaybackRate: Float = 1.0
    var sampleRate = 0.05
    var secondsOfIncreasedPlayback = 0.0
    var skippedSeconds = 0.0
    
    // Keys
    let AudioPlayerEpisodeUserInfoKey = "AudioPlayerEpisodeUserInfoKey"
    let AudioPlayerSecondsElapsedUserInfoKey = "AudioPlayerSecondsElapsedUserInfoKey"
    let AudioPlayerSecondsRemainingUserInfoKey = "AudioPlayerSecondsRemainingUserInfoKey"
    let AudioPlayerSecondsSkippedKey = "AudioPlayerSecondsSkippedKey"
    
    func setEpisode(_ episode: Episode) {
        
        self.episode = episode
        skippedSeconds = episode.secondsSkipped
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
    
        resumeEpisode()
    }
    
    func resumeEpisode() {
        if let currentEp = episode {
            guard let audio = self.player else {
                debugPrint("ERROR: Trying to play but player hasn't been instantiated")
                return
            }
            
            // Seek to position
            if currentEp.playPosition > 0 {
                forward(by: currentEp.playPosition)
            }
            
            // Play
            play()
            toggleSkipSilence()
        }
    }
    
    func play() {
        if let currentEp = episode {
            guard let audio = self.player else {
                debugPrint("ERROR: Trying to play but player hasn't been instantiated")
                return
            }
            
            // Play
            audio.play()
            setupNowPlaying()
            
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
        updateCommandCenter()
        timer?.invalidate()
    }
    
    func forward(by: Double) {
        guard let audio = self.player else {return}
        debugPrint("Forward")
        audio.seek(by)
        updateCommandCenter()
    }
    
    func back(by: Double) {
        guard let audio = self.player else {return}
        debugPrint("Back")
        audio.seek(by * -1)
        updateCommandCenter()
    }
    
    func stop() {
        guard let audio = self.player else {return}
        debugPrint("Stop")
        audio.stop()
        timer?.invalidate()
        updateCommandCenter()
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
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeSpokenAudio, options: [])
            debugPrint("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            registerForRemoteCommands()
            setupNowPlaying()
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
    
    func toggleSkipSilence() {
        if shouldSkipSilences {
            playerTimeObserver?.invalidate()
            shouldSkipSilences = false
        } else {
            // Timer for skip silence
            playerTimeObserver = Timer.scheduledTimer(timeInterval: sampleRate, target: self, selector: #selector(findSilences), userInfo: nil, repeats: true)
            shouldSkipSilences = true
        }
    }
    
    @objc private func udateProgress() {
        if let audio = player, let episode = episode {
            
            // Save updated tiem to episode
            episode.playPosition = audio.currentTime
            episode.secondsSkipped = skippedSeconds
            self.db.save(episode.detatch())
            
            // Notify
            NotificationCenter.default.post(name: .audioPlayerPlaybackTimeChanged, object: self, userInfo: [
                AudioPlayerSecondsElapsedUserInfoKey: audio.timeElapsed,
                AudioPlayerSecondsRemainingUserInfoKey: audio.timeRemaining,
                AudioPlayerSecondsSkippedKey: skippedSeconds
            ])
        }
    }
    
    private func updateCommandCenter() {
        if let player = self.player {
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        }
    }
    
    // https://blog.breaker.audio/how-we-skip-silences-in-podcasts-with-avaudioplayer-69232b57850a
    @objc private func findSilences() {
        guard player?.isPlaying == true else { return }
        player?.updateMeters()
        if let averagePower = player?.averagePower(forChannel: 0),
            averagePower < decibelThreshold {
            player?.rate = 3
            skippedSeconds += sampleRate - (sampleRate / 3)
            debugPrint("Skipped: \(skippedSeconds) seconds")
        } else {
            player?.rate = defaultPlaybackRate
        }
    }
    
    // MARK: Now Playing
    
}
