//
//  Constants.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct Constant {
    
    static let BASE_URL = "http://84.38.183.119:5000/"
    
    static let MERCHANT_ID = "merchant.com.nft.dev"
    
    static let YOOKASSA_MERCHANT_ID = "830830"
    
    static let YOOKASSA_KEY = "test_ODMwODMwwD5_Ww8BV_CO7Hxkk9VpJbBg_neR-utDEEM"
    
    static let YOOKASSA_SEKRET = "test_G0RlKiZhvtiq4p7p0UTy2aY868elZr1KPdE0TbuW3pQ"
    
    static var AUTH_TOKEN = UserDefaults.standard.object(forKey: "authToken") as? String ?? ""
    
    static var USER_ID = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
    
}

