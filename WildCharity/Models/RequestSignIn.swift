//
//  RequestSignIn.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import Alamofire

struct RequestSignIn: Codable {
    var email: String
    var password: String
    
    func conventParameters() -> Parameters{
        let par: Parameters = [
            "email": email,
            "password": password]
        return par
    }
}
