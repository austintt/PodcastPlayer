//
//  PlayerSwipeViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 9/8/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class PlayerSwipeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var episode: Episode!
    let layout = UICollectionViewFlowLayout()
    let player = PlayerViewController()
    var pages = [UIView]()
    var hasScrolled = false
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var podcastNameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyle()
        setUpCollectionView()
        setUpPages()
        setUpContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !hasScrolled && !pages.isEmpty {
            hasScrolled = true
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionViewScrollPosition.right, animated: false)
        }
    }
    
    func setUpStyle() {
        
        // Buttons
        closeButton.tintImage(color: Constants.shared.purple)
        
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .blue
        collectionView.register(PlayerViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.isPagingEnabled = true
        
        // Flow Layout
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
    }
    
    func setUpPages() {
        
        // settings controlls
        let settingsController = storyboard!.instantiateViewController(withIdentifier: "PlayerSettingsView")
        addChildViewController(settingsController)
        pages.append(settingsController.view)
        
        // player controlls
        let playerController = storyboard!.instantiateViewController(withIdentifier: "PlayerViewController")
        addChildViewController(playerController)
        if let playerView = playerController as? PlayerViewController {
            playerView.episode = episode
            pages.append(playerController.view)
        }
        
        // notes controlls
        let notesController = storyboard!.instantiateViewController(withIdentifier: "PlayerNotesView")
        addChildViewController(notesController)
        pages.append(notesController.view)
    }
    
    func setUpContent() {
        if let episode = episode {
            episodeTitleLabel.text = episode.title
            podcastNameLabel.text = episode.podcastName
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeToDismiss(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! PlayerViewCell
        cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .green
        cell.addSubview(pages[indexPath.item])
        cell.layoutIfNeeded()
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
