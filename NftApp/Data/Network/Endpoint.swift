//
//  Endpoint.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct Endpoint {
    
    let url: String
    let method: HTTPMethod
    var bodyParameters: EncodableProtocol? = nil
    var urlParameters: [String: Any]? = nil
    
}
