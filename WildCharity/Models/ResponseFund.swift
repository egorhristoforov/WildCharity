//
//  ResponseFund.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

struct ResponseFund: Codable {
    var fonds: [Fund]
}

struct Fund: Codable {
    var uid: Int
    var name: String
    var description: String
    var email: String
    var account: String
    var logo_url: String
    var background_url: String
    var site_url: String
    var inn: String
    var address: String
    var post_address: String
    var bank_name: String
    var settlment_account: String
    var cor_account: String
    var bic: String
    var kpp: String
}
