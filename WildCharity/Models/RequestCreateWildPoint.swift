//
//  RequestCreateWildPoint.swift
//  WildCharity
//
//  Created by Egor on 29/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import Alamofire

struct RequestCreateWildPoint: Codable {
    
    var lon: Double
    var lat: Double
    var localId: String
    
    func conventParameters() -> Parameters{
        let par: Parameters = [
            "lon": lon,
        "lat": lat,
        "localId": localId]
        return par
    }
}
