//
//  Constants.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct Constant {
    
//    static let BASE_URL = "http://80.249.145.13:5000/"
    static let BASE_URL = "http://showyouryup.com:5000/"
    
    static let MERCHANT_ID = "merchant.com.nft.dev"
    
    static let TERMINAL_KEY_T = ""
    
    static let PUBLIC_KEY_T = ""
    
    static let IAP_SECRET = ""
    
    static let IN_APP_PRODUCTS: Set<String> = [
        "com.nft.dev.purchase1",
        "com.nft.dev.purchase2",
        "com.nft.dev.purchase3",
        "com.nft.dev.purchase4"
    ]
        
    static var AUTH_TOKEN = UserDefaults.standard.object(forKey: "authToken") as? String ?? ""
    
    static var USER_ID = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
    
}

