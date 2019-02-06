//
//  PlayerNotesViewer.swift
//  Podcast
//
//  Created by Austin Tooley on 2/6/19.
//  Copyright © 2019 Austin Tooley. All rights reserved.
//

import UIKit
import WebKit

class PlayerNotesViewController: UIViewController {
    
    @IBOutlet weak var notesView: WKWebView!
    
    override func viewDidLoad() {
        configureNotesView()
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func configureNotesView() {
    }
    
    public func loadEpisodeShowNotes() {
        if let showNotes = AudioPlayer.shared.episode?.showNotes {
            let html = "<head><style>\(Constants.notesStyle)</style></head><body>\(showNotes)</body>"
            notesView.loadHTMLString(html, baseURL: nil)
        }
    }
    
}



