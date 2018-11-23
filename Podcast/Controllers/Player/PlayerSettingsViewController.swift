//
//  PlayerSettingsViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 9/8/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class PlayerSettingsViewController: UIViewController {
    
    @IBOutlet weak var skipSilenceButton: UIButton!
    @IBOutlet weak var playbackRateButton: UIButton!
    @IBOutlet weak var enhanceAudioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyle()
        setUpContent()
    }
    
    func setUpContent() {
        
    }
    
    func setUpStyle() {
        if AudioPlayer.shared.shouldSkipSilences {
            skipSilenceButton.setFilledInStyle(color: Constants.shared.blue)
        } else {
            skipSilenceButton.setOutlineStyle(color: Constants.shared.blue)
        }
        
        playbackRateButton.setOutlineStyle(color: Constants.shared.yellow)
        enhanceAudioButton.setOutlineStyle(color: Constants.shared.red)
    }

    
    @IBAction func toggleSkipSilence(_ sender: Any) {
        if AudioPlayer.shared.shouldSkipSilences {
            skipSilenceButton.setOutlineStyle(color: Constants.shared.blue)
            AudioPlayer.shared.toggleSkipSilence()
        } else {
            skipSilenceButton.setFilledInStyle(color: Constants.shared.blue)
            AudioPlayer.shared.toggleSkipSilence()
        }
    }
    
    @IBAction func togglePlaybackRate(_ sender: Any) {
    }
    
    @IBAction func toggleEnhanceAudio(_ sender: Any) {
    }
}
