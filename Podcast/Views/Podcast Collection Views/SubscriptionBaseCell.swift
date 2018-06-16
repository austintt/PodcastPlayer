//
//  SubscriptionBaseCell.swift
//  Podcast
//
//  Created by Austin Tooley on 6/16/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

protocol SubscriptionCell {
    var hasBeenConstructed: Bool { get set}
    func constructCell()
    func updateContent(podcast: Podcast)
}
