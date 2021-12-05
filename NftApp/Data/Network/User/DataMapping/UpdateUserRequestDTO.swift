//
//  UpdateUserRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 04.12.2021.
//

import Foundation

struct UpdateUserRequestDTO: EncodableProtocol {
    
    var id = Constant.USER_ID
    var login: String?
    var email: String?
    var oldPassword: String?
    var newPassword: String?
    var inviteWord: String?
    
}
