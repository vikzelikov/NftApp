//
//  Constants.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct Constant {
    
    static let BASE_URL = "http://80.249.144.63:5000/"
    
    static let MERCHANT_ID = "merchant.com.nft.dev"
    
    static let TERMINAL_KEY_T = "1632305973794"
    
    static let PUBLIC_KEY_T = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv5yse9ka3ZQE0feuGtemYv3IqOlLck8zHUM7lTr0za6lXTszRSXfUO7jMb+L5C7e2QNFs+7sIX2OQJ6a+HG8kr+jwJ4tS3cVsWtd9NXpsU40PE4MeNr5RqiNXjcDxA+L4OsEm/BlyFOEOh2epGyYUd5/iO3OiQFRNicomT2saQYAeqIwuELPs1XpLk9HLx5qPbm8fRrQhjeUD5TLO8b+4yCnObe8vy/BMUwBfq+ieWADIjwWCMp2KTpMGLz48qnaD9kdrYJ0iyHqzb2mkDhdIzkim24A3lWoYitJCBrrB2xM05sm9+OdCI1f7nPNJbl5URHobSwR94IRGT7CJcUjvwIDAQAB"
        
    static var AUTH_TOKEN = UserDefaults.standard.object(forKey: "authToken") as? String ?? ""
    
    static var USER_ID = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
    
}

