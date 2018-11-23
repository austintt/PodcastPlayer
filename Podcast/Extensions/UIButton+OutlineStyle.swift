//
//  UIButton+OutlineStyle.swift
//  Podcast
//
//  Created by Austin Tooley on 9/8/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setOutlineStyle(color: UIColor) {
        self.backgroundColor = .clear
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 8
        self.tintColor = color
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.textAlignment = .center
    }
    
    func setFilledInStyle(color: UIColor) {
        self.backgroundColor = color
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 8
        self.tintColor = .white
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.textAlignment = .center
    }
}


