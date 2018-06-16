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
    let db = DatabaseController<Episode>()
    var audio: AVAudioPlayer?
    var episode: Episode?
    var timer: Timer?
    var decibelThreshold: Float = -40
    var samplingRate = 0.05
    var secondsOfIncreasedPlayback = 0.0
    
    func setEpisode(_ episode: Episode) {
        
        self.episode = episode.detatch()
    }
    
    func play(_ newEpisode: Episode? = nil) {
        // Hanlde a new episode if we have one
        if let newEpisode = newEpisode {
            setEpisode(newEpisode)
            
            // Grab file
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("\(newEpisode.generateFileName()).\(newEpisode.fileExtension)")
            
            let url = documentsURL
            
            // Get ready to play
            do {
                audio = try AVAudioPlayer(contentsOf: url)
                guard let audio = audio else {return}
                setupPlayer()
                audio.prepareToPlay()
    
            } catch {
                debugPrint("Couln't load the file :(")
            }
        }
        
        if let currentEp = episode {
            guard let audio = self.audio else {return}
            
            // Play
            // TODO: For some reason I can't just play at 0 with playAtTime, figure it out.
            // We also appear to be skipping 10 seonds on resume
            if currentEp.playPosition > 0 {
                audio.play(atTime: TimeInterval(currentEp.playPosition))
            }else {
                audio.play()
            }
            debugPrint("Play")
            
            // Timer to keep track of progress
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(udateProgress), userInfo: nil, repeats: true)
        }
    }
    
    func pause() {
        guard let audio = self.audio else {return}
        
        debugPrint("Pause")
        audio.pause()
        timer?.invalidate()
    }
    
    func forward(by: Double) {
        guard let audio = self.audio else {return}
        debugPrint("Forward")
        audio.seek(by)
    }
    
    func back(by: Double) {
        guard let audio = self.audio else {return}
        debugPrint("Back")
        audio.seek(by * -1)
    }
    
    func stop() {
        guard let audio = self.audio else {return}
        debugPrint("Stop")
        audio.stop()
        timer?.invalidate()
    }
    
    func isPlaying() -> Bool {
        if let audioState = audio?.isPlaying {
            return audioState
        }
        return false
    }
    
    func setupPlayer() {
        audio?.isMeteringEnabled = true
        audio?.enableRate = true
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeSpokenAudio, options: [.allowAirPlay, .allowBluetooth])
            debugPrint("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            debugPrint("Session is Active")
        } catch {
            debugPrint("Error setting up audio session \(error)")
        }
    }
    
    @objc private func udateProgress() {
        if let audio = audio, let episode = episode {
            episode.playPosition = audio.currentTime
            self.db.save(episode)
            debugPrint("Progress: \(audio.currentTime)")
        }
    }
    
    // https://blog.breaker.audio/how-we-skip-silences-in-podcasts-with-avaudioplayer-69232b57850a
    
}
