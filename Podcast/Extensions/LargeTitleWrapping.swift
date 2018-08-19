//
//  LargeTitleWrapping.swift
//  Podcast
//
//  Created by Austin Tooley on 8/15/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

extension UIViewController {
    func setMultilineLargeNavTitle() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        for navItem in (self.navigationController?.navigationBar.subviews)! {
            for itemSubView in navItem.subviews {
                if let largeLabel = itemSubView as? UILabel {
                    largeLabel.text = self.title
                    largeLabel.numberOfLines = 0
                    largeLabel.lineBreakMode = .byWordWrapping
                }
            }
        }
        self.navigationController?.navigationBar.layoutSubviews()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
}
