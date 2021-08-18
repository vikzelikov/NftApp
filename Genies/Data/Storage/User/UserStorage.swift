//
//  UserStorage.swift
//  Genies
//
//  Created by Yegor on 19.08.2021.
//

import Foundation


protocol UserStorage {
        
    func saveAuthToken(token: String)
    
    func saveUserId(userId: Int)
        
    func getUserId() -> Int
    
    func clearUserStorage()
    
}

class UserStorageImpl: UserStorage  {

    func saveAuthToken(token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    func saveUserId(userId: Int) {
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    
    func getUserId() -> Int {
        UserDefaults.standard.integer(forKey: "userId")
    }
    
    func clearUserStorage() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }

}
