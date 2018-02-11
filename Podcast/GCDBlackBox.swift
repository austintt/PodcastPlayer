//
//  GCDBlackBox.swift
//  FlickFinder
//
//  Created by Austin Tooley on 03/11/17.
//  Copyright © 2017 Austin Tooley. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
