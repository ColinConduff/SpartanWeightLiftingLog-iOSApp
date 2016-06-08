//
//  SpartanAPI.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

// MARK: - SpartanAPI: NSObject

class SpartanAPI : NSObject {
    
    // MARK: Properties
    
    var session = NSURLSession.sharedSession()
    var requestToken: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(path: String, parameters: [String:AnyObject]?, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: createURLFromParameters(parameters, withPathExtension: path))
        request.addValue("Bearer" + requestToken!, forHTTPHeaderField: "Authorization")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                print("Status Code: \((response as? NSHTTPURLResponse)!.statusCode)")
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(path: String, parameters: [String:AnyObject]?, jsonBody: NSData?, withToken: Bool, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: createURLFromParameters(parameters, withPathExtension: path))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if withToken {
            request.addValue("Bearer" + requestToken!, forHTTPHeaderField: "Authorization")
        }
        request.HTTPBody = jsonBody
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                let statusCode = (response as? NSHTTPURLResponse)!.statusCode
                print("Status Code: \(statusCode)")
                
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
                
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if statusCode == 204 {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandler(nil, completionHandlerForConvertData: completionHandlerForPOST)
            } else {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: PUT
    
    func taskForPUTMethod(path: String, parameters: [String:AnyObject]?, jsonBody: NSData?, completionHandlerForPUT: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: createURLFromParameters(parameters, withPathExtension: path))
        request.HTTPMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer" + requestToken!, forHTTPHeaderField: "Authorization")
        request.HTTPBody = jsonBody
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                print("Status Code: \((response as? NSHTTPURLResponse)!.statusCode)")
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(result: nil, error: NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    
    func taskForDELETEMethod(path: String, completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: createURLFromParameters(nil, withPathExtension: path))
        request.HTTPMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer" + requestToken!, forHTTPHeaderField: "Authorization")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                print("Status Code: \((response as? NSHTTPURLResponse)!.statusCode)")
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(result: nil, error: NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(nil, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData?, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        if let data = data {
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            }
            
            completionHandlerForConvertData(result: parsedResult, error: nil)
        } else {
            completionHandlerForConvertData(result: nil, error: nil)
        }
    }
    
    // create a URL from parameters
    private func createURLFromParameters(parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "spartan-weight-lifting-log.herokuapp.com"
        components.path = "/api/v1/" + (withPathExtension ?? "")
        
        if let parameters = parameters {
            components.queryItems = [NSURLQueryItem]()
            for (key, value) in parameters {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        print(components.URL!)
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> SpartanAPI {
        struct Singleton {
            static var sharedInstance = SpartanAPI()
        }
        return Singleton.sharedInstance
    }
}