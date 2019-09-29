//
//  ResponseSignUp.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

struct ResponseAuth: Codable {
    var user: User
}

struct User: Codable {
    var local_id: String
    var name: String
    var account: Int
    var idToken: String
    var email: String
}
