//
//  AVPlayer+TimeProvider.swift
//  Podcast
//
//  Created by Austin Tooley on 5/7/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
    func seek(_ by: Double) {
        // add new time
        let newTime = TimeInterval(self.currentTime + by)
        
        // seek
        self.currentTime = newTime
    }
    
    var timeElapsed: Double {
        return self.currentTime as Double
    }
    
    var timeRemaining: Double {
        return self.duration - self.currentTime as Double
    }
}

extension TimeInterval {
    func timeString() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
