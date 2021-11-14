//
//  UserStorage.swift
//  NftApp
//
//  Created by Yegor on 19.08.2021.
//

import Foundation


protocol UserStorage {
        
    func saveAuthToken(token: String)
    
    func saveUserId(userId: Int)
    
    func saveInvitingState()
    
    func removeInvitingState()
        
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
    
    func saveInvitingState() {
        UserDefaults.standard.set(true, forKey: "isInvitingState")
    }
    
    func removeInvitingState() {
        UserDefaults.standard.removeObject(forKey: "isInvitingState")
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
