//
//  RequestManager.swift
//  Podcast
//
//  Created by Austin Tooley on 2/11/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import Foundation

class RequestManager: NSObject {
    
    // MARK: Initializer
    var session = URLSession.shared
//    var locations = [Location]()
    
    
    // MARK:  POST
    func taskForPostMethod(url: URL, jsonBody: String, completionHandlerForPost: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, configure request
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
//        request.addValue(ServiceManager.Constants.parseApplicationId, forHTTPHeaderField: ServiceManager.ParemeterKeys.applicaitonId)
//        request.addValue(ServiceManager.Constants.parseApiKey, forHTTPHeaderField: ServiceManager.ParemeterKeys.applicationKey)
        print("Request: \(request)")
        
        // Make request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // Verify request
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPost(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD, was there an error?
            guard (error == nil) else {
//                sendError("There was an error with your request: \(error)")
                return
            }
            
            // GUARD, did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if (response as? HTTPURLResponse)?.statusCode == 403 {
                    sendError("403 - Incorrect credtntials.")
                } else {
                    sendError("Network failure. HTTP Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                }
                return
            }
            
            // GUARD, was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Get rid of those annoying first 5 characters 😖
            //            let range = Range(uncheckedBounds: (5, data.count))
            //            let trimmedData = data.subdata(in: range)
            
            // Parse and use data
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPost)
            
        }
        
        //start the request
        task.resume()
        return task
    }
    
    // MARK: GET
    func taskForGETMethod(url: URL, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(ServiceManager.Constants.parseApplicationId, forHTTPHeaderField: ServiceManager.ParemeterKeys.applicaitonId)
//        request.addValue(ServiceManager.Constants.parseApiKey, forHTTPHeaderField: ServiceManager.ParemeterKeys.applicationKey)
        
        print("GETTING")
        print("URL: \(url)")
        print("REQUEST: \(request)")
        
        // Make the request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: did we have an error?
            guard (error == nil) else {
//                sendError("There was an error with your request: \(error)")
                return
            }
            
            
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if (response as? HTTPURLResponse)?.statusCode == 403 {
                    sendError("403: Incorrect credtntials.")
                } else {
                    sendError("Network failure. HTTP Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse and use data
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        //start the request
        task.resume()
        return task
    }
    
    // given raw JSON, return a usable object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        print("PARSING data: \(data)")
        
        // Get rid of those annoying first 5 characters 😖
        let convertedData = (NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        var preParsedResult = String(convertedData)
        preParsedResult = preParsedResult.replacingOccurrences(of: ")]}'", with: "")
        
        // Convert to dictionary
        if let sanitizedData = preParsedResult.data(using: .utf8) {
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: sanitizedData, options: .allowFragments) as AnyObject
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(sanitizedData)'"]
                completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            }
            //            print("PARSED DATA: \(parsedResult))")
            completionHandlerForConvertData(parsedResult, nil)
        }
    }
    
    // Shared instance
    class func sharedInstance() -> RequestManager {
        struct Singleton {
            static var sharedInstance = RequestManager()
        }
        return Singleton.sharedInstance
    }
    
}

