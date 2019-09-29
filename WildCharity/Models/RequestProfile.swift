//
//  RequestProfile.swift
//  WildCharity
//
//  Created by Egor on 29/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import Alamofire

struct RequestProfile: Codable {
    var localId: String
    
    func conventParameters() -> Parameters{
        let par: Parameters = [
            "localId": localId]
        return par
    }
}
