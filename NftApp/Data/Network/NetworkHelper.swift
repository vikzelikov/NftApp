//
//  NetworkHelper.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

enum NetworkError {
    
    case error
    case notConnected
    case cancelled
    
}

struct ErrorMessage: Error {
    
    var errorType: NetworkError
    var errorDTO: ErrorDTO?
    var code: Int?
    
}

struct HTTPCode {
    
    static let ok = 200
    static let badRequest = 400
    static let unauthorized = 401
    static let notFound = 404
    static let internalServerError = 500
    
}

enum HTTPMethod: String {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"

}

protocol EncodableProtocol: Encodable {

    func encode() -> Data?

}

extension EncodableProtocol {

    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }

}

struct NetworkHelper {
    
    static func request<T : Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard var components = URLComponents(string: endpoint.url) else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
            fatalError("Error URLComponents")
        }
        
        components.queryItems = getUrlParameters(parameters: endpoint.urlParameters)
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        guard let url = components.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
            fatalError("Error URL")
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(Constant.AUTH_TOKEN)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 5
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.bodyParameters?.encode()
                
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            self.validateResponse(data: data, response: response, error: error, completion: completion)
            
        }.resume()
    }
    
    static func uploadMedia<T : Decodable>(
        endpoint: Endpoint,
        request: UploadMediaRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard
            let url = URL(string: endpoint.url),
            let imageData = request.image.jpegData(compressionQuality: 0.1)
        else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
            fatalError("Error URL or image")
        }
        
        var request = URLRequest(url: url)
        let boundary = UUID().uuidString
        request.httpMethod = "PUT"
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Constant.AUTH_TOKEN)", forHTTPHeaderField: "Authorization")

        var body = Data()
        let fieldName = "image"
        let fileName = "image"

        body.append("\r\n--\(boundary)\r\n".data(using: .utf8) ?? Data())
        body.append(
            "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)
            ?? Data()
        )
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8) ?? Data())
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8) ?? Data())
        
        URLSession.shared.uploadTask(with: request, from: body, completionHandler: { data, response, error in
            
            self.validateResponse(data: data, response: response, error: error, completion: completion)
            
        }).resume()
    }
    
    private static func validateResponse<T : Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        DispatchQueue.main.async {
            if let error = error {
                completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: nil)))
                print("Error making request: \(error.localizedDescription) from \(T.self)")
            }
                
            if let httpCode = (response as? HTTPURLResponse)?.statusCode, let data = data {
                if let responseDTO = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(responseDTO))
                    return
                } else {
                    if let errorDTO = try? JSONDecoder().decode(ErrorDTO.self, from: data) {
                        let error = ErrorMessage(errorType: .error, errorDTO: errorDTO, code: httpCode)
                        completion(.failure(error))
                        return
                    } else {
                        completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: httpCode)))
                        fatalError("DTO not compare \(httpCode)")
                    }
                }
            }
        }
    }
    
    private static func getUrlParameters(parameters: [String: Any]?) -> [URLQueryItem]? {
        guard let urlParameters = parameters else { return nil }
        
        return urlParameters.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
    
}
