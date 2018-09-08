//
//  ContainerViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 6/17/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var miniBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var miniBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var miniBarContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
    }
    
    func registerNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(hideMiniBar(_:)), name: .episodeDetailViewLoaded, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showMiniBar(_:)), name: .episodeDetailViewWillDisappear, object: nil)
    }
    
    @objc func hideMiniBar(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.miniBarBottomConstraint.constant = self.miniBarHeightConstraint.constant
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func showMiniBar(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.miniBarBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}
