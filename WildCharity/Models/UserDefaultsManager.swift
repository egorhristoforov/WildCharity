//
//  UserDefaults.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    private static var uniqueInstance: UserDefaultsManager?
    
    
    private init() {}
    
    static func shared() -> UserDefaultsManager {
        if uniqueInstance == nil {
            uniqueInstance = UserDefaultsManager()
        }
        return uniqueInstance!
    }
    
    public func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "TOKEN")
    }
    
    public func setToken(_ token: String?) {
        UserDefaults.standard.set(token, forKey: "TOKEN")
    }
    
    public func getLocalId() -> String? {
        return UserDefaults.standard.string(forKey: "ID")
    }
    
    public func setLocalId(_ id: String?) {
        UserDefaults.standard.set(id, forKey: "ID")
    }
}
