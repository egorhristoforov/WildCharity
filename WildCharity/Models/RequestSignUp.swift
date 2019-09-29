//
//  RequestSignUp.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import Alamofire

struct RequestSignUp: Codable {
    var email: String
    var password: String
    var name: String
    
    func conventParameters() -> Parameters{
        let par: Parameters = [
            "email": email,
            "password": password,
            "name":  name]
        return par
    }
}
