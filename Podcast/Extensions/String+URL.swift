//
//  String+URL.swift
//  Podcast
//
//  Created by Austin Tooley on 4/15/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

extension String {
    
    func toURL() -> URL? {
        return URL(string: self)
    }
}
