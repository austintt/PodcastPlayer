//
//  ImageView+Style.swift
//  Podcast
//
//  Created by Austin Tooley on 6/16/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

extension UIImageView {
    func roundedCorners(radius: CGFloat = CGFloat(Constants.shared.cornerRadius)) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
