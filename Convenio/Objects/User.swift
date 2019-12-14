//
//  User.swift
//  Convenio
//
//  Created by Anshay Saboo on 11/30/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation

class User {
    var id = ""
    var firstName = ""
    var lastName = ""
    var email = ""
    var password = ""
    var schoolName = ""
    
    init() {}
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
}
