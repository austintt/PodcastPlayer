//
//  PodcastColumnFlowLayout.swift
//  Podcast
//
//  Created by Austin Tooley on 6/12/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

/// Check out [A Tour of UICollectionView](https://developer.apple.com/videos/play/wwdc2018/225/)
class PodcastColumnFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        
        let availableWidth = cv.bounds.size.width - (cv.layoutMargins.left + cv.layoutMargins.right)
        let minColumnWidth = CGFloat(300.0)
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        self.itemSize = CGSize(width: cellWidth, height: 115.0)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0) // so we have some space at the top
        self.sectionInsetReference = .fromSafeArea // Safe inside safe area
    }
}
