//
//  Constants.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct Constant {
    
    static let BASE_URL = "http://80.249.147.240:5000"
    
    static var AUTH_TOKEN = UserDefaults.standard.object(forKey: "authToken") as? String ?? ""
    
}

