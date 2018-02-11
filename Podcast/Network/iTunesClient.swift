//
//  iTunesClient.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation

extension RequestManager {
    
    func getSearch(term: String, competionHandlerForSearch: @escaping (_ results: [Podcast]?, _ error: NSError?) -> Void) {
        let params = [ParameterRequestKeys.term: term, ParameterRequestKeys.media: ParameterRequestValues.podcast] as [String:AnyObject]
        let method = Methods.search
        let url = iTunesUrlFromParameters(params, withPathExtension: method)
        
        let _ = taskForGETMethod(url: url, completionHandlerForGET: { (results, error) in
            
            // check for error
            if let error = error {
                competionHandlerForSearch(nil, error)
            } else {
                if let results = results?["results"] as? [[String:AnyObject]] {
                    let podcasts = Podcast.podcastsFromResults(results)
                    competionHandlerForSearch(podcasts, nil)
                } else {
                    competionHandlerForSearch(nil, NSError(domain: "getSearch parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse search results"]))
                }
            }
        })
    }
    
    // Create URL from params
    private func iTunesUrlFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        // Construct URL
        var components = URLComponents()
        components.scheme = RequestManager.Constants.iTunesApiScheme
        components.host = RequestManager.Constants.iTunesApiHost
        components.path = (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        // Add params
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
