//
//  Constants.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation

extension RequestManager {
    
    
    // MARK: iTunes Search
    struct Url {
        static let iTunesApiScheme = "https"
        static let iTunesApiHost = "itunes.apple.com"
        static let query = "?"
    }
    
    // MARK: Methods
    struct Methods {
        static let search = "/search"
    }
    
    // MARK: Parameter Keys
    struct ParameterRequestKeys {
        static let term = "term"
        static let media = "media"
        static let limit = "limit"
    }
    
    struct ParameterRequestValues {
        static let podcast = "podcast"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Podcast
        static let podcastName = "collectionName"
        static let artworkUrl = "artworkUrl600"
        static let feedUrl = "feedUrl"
        static let artist = "artistName"
    }
    
    
}
