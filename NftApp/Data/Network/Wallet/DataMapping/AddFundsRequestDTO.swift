//
//  AddFundsRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import PassKit

class AddFundsRequestDTO {
    private var paymentData: PKPayment
    
    init(paymentData: PKPayment) {
        self.paymentData = paymentData
    }
    
    lazy var parameters = [
        "amount": [
            "value": "200.00",
            "currency": "RUB"
        ],
        "payment_method_data": [
            "type": "apple_pay",
            "payment_data": String(data: paymentData.token.paymentData.base64EncodedData(), encoding: .utf8)
        ],
        "description": "some scription"
    ] as [String : Any]
    
}
