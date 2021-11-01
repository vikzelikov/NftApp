//
//  Endpoint.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

struct Endpoint {
    let url: String
    let method: HTTPMethod
    let headers: HTTPHeaders
    let data: [String : Any]?
}
