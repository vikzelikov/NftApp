//
//  WalletRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class WalletRepositoryImpl: WalletRepository {
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<AddFundsResponseDTO, Error>) -> Void) {

        let endpoint = WalletEndpoints.addFundsEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        let username = Constant.YOOKASSA_MERCHANT_ID
        let password = Constant.YOOKASSA_SEKRET
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("wefwqefqwefq" + String(CACurrentMediaTime()), forHTTPHeaderField: "Idempotence-Key")
  
        request.httpBody = try? JSONSerialization.data(withJSONObject: endpoint.data!)


        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON!)
        }

        task.resume()
        
    }
    
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<WithdrawFundsResponseDTO, Error>) -> Void) {

        let endpoint = WalletEndpoints.withdrawFundsEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
