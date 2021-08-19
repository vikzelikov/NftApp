//
//  Constants.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct Constant {
    
    static let BASE_URL = "http://asgard-invest.org"
    
    static let AUTH_TOKEN = UserDefaults.standard.object(forKey: "authToken") as? String ?? ""
    
}
