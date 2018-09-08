//
//  UIButton+ImageTint.swift
//  Podcast
//
//  Created by Austin Tooley on 9/8/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

extension UIButton {
    func tint(image: UIImage, color: UIColor) {
        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(image, for: .normal)
        self.imageView?.tintColor = color
    }
    
    func tintImage(color: UIColor) {
        if let image = self.imageView?.image {
            self.imageView?.contentMode = .scaleAspectFit
            self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            self.imageView?.tintColor = color
        }
    }
}
