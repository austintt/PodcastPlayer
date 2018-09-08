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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpPages()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !hasScrolled  {
            hasScrolled = true
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionViewScrollPosition.right, animated: false)
        }
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
