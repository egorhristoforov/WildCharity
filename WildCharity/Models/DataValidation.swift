//
//  DataValidation.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class DataValidation {
    func validateName(name: String) -> Bool {
        if name.count > 1 {
            let range = NSRange(location: 0, length: name.count)
            let reg = "^[a-zA-ZА-Яа-яЁё]{1,30}$"
            let regex = try! NSRegularExpression(pattern: reg)
            if regex.firstMatch(in: name, options: [], range: range) != nil{
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    func validatePassword(pass: String) -> Bool {
        let reg = "^(?=.*\\d)(?=.*[a-zA-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,32}$"
        let range = NSRange(location: 0, length: pass.count)
        let regex = try! NSRegularExpression(pattern: reg)
        if regex.firstMatch(in: pass, options: [], range: range) != nil{
            return true
        } else {
            return false
        }
    }

    func validateEmail(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.count)
        let reg = "^[a-zA-Z]{1,2}[A-Za-z0-9._-]{0,62}[@]{1}[A-Za-z]{2}[A-Za-z0-9.-]{0,8}[.]{1}[A-Za-z]{2,255}$"
        let regex = try! NSRegularExpression(pattern: reg)
        if regex.firstMatch(in: email, options: [], range: range) != nil{
            return true
        } else {
            return false
        }
    }
}
