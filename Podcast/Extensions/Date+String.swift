//
//  Date+String.swift
//  Podcast
//
//  Created by Austin Tooley on 8/4/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation

extension Date {
    func toMediumString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.timeStyle = DateFormatter.Style.none
        
        return dateformatter.string(from: Date())
    }
}
