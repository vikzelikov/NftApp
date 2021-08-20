//
//  Endpoint.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

struct Endpoint {
    let url: URL?
    let method: HTTPMethod
    let headers: HTTPHeaders
    let data: [String : Any]?
}
