//
//  UserManager.swift
//  Convenio
//
//  Created by Anshay Saboo on 11/30/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation
import Alamofire

// handles login, registration, and data updating
class UserManager {
    
    // MARK:- Log in
    
    /// Log in with email and password, returns a User object
    func logIn(email: String, password: String, completion: (Bool) -> Void) {
        
    }
    
    // MARK:- Registration
    
    /// Registers a new user object in the backend
    func signUpNewUser(user: User, completion: (Bool) -> Void) {
        
    }
    
    /// Verifies that the given id exists, and is not already associated with an account
    func verifyRegistrationID(id: String, completion: (String, String) -> Void) {
        
    }
    
}
