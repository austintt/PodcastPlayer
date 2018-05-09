//
//  AVPlayer+TimeProvider.swift
//  Podcast
//
//  Created by Austin Tooley on 5/7/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import AVFoundation

protocol AVPlayerItemTimeProvider {
    func currentTime() -> CMTime
    var duration: CMTime { get }
}

extension AVPlayerItemTimeProvider {
    var timeElapsed: Double {
        return self.currentTime().seconds
    }
    
    var timeRemaining: Double {
        return self.duration.seconds - self.timeElapsed
    }
}

extension AVPlayerItem: AVPlayerItemTimeProvider {}
