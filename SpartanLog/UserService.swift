//
//  LoginService.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

extension SpartanAPI {
    
    func login(email: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let path = "auth/login"
        
        let jsonBodyDictionary = [
            "email": "test@gmail.com",//email,
            "password": "123456"//password
        ]
        
        var jsonBody: NSData?
        do {
            jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonBodyDictionary, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        
        let errorMessage = "Login Failed"
        
        loginAndRegisterBase(path, jsonBody: jsonBody!, errorMessage: errorMessage, completionHandler: completionHandler)
    }
    
    func register(name: String, email: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let path = "auth/signup"
        
        let jsonBodyDictionary = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        var jsonBody: NSData?
        do {
            jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonBodyDictionary, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        
        let errorMessage = "Registration Failed"
        
        loginAndRegisterBase(path, jsonBody: jsonBody!, errorMessage: errorMessage, completionHandler: completionHandler)
    }

    
    func loginAndRegisterBase(path: String, jsonBody: NSData, errorMessage: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 2. Make the request */
        taskForPOSTMethod(path, parameters: nil, jsonBody: jsonBody, withToken: false) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: errorMessage)
                
            } else {
                if let requestToken = results["token"] as? String {
                    self.requestToken = requestToken
                    completionHandler(success: true, errorString: nil)
                    
                } else {
                    print("Could not find token in \(results)")
                    completionHandler(success: false, errorString: errorMessage)
                }
            }
        }
    }
}
