//
//  LoginService.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

extension SpartanAPI {
    func login(password: String?, email: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let jsonBodyDictionary = [
            "email": "test@gmail.com",
            "password": "123456"
        ]
        
        var jsonBody: NSData?
        do {
            jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonBodyDictionary, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        
        /* 2. Make the request */
        taskForPOSTMethod("auth/login", parameters: nil, jsonBody: jsonBody!, withToken: false) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Login Failed (Request Token).")
                
            } else {
                if let requestToken = results["token"] as? String {
                    self.requestToken = requestToken
                    completionHandler(success: true, errorString: nil)
                    
                } else {
                    print("Could not find token in \(results)")
                    completionHandler(success: false, errorString: "Login Failed (Request Token).")
                }
            }
        }
    }
}
