//
//  ErrorHelper.swift
//  NftApp
//
//  Created by Yegor on 29.09.2021.
//

import Foundation

struct ErrorHelper {
    
    static func validateError(error: Error) -> (Int, String?) {
        var httpCode: Int = HTTPCode.badRequest
        var errorStr: String?
        
        if let error = error as? ErrorMessage, let code = error.code {
            
            httpCode = code

            switch code {
            case let c where c >= HTTPCode.internalServerError:
                errorStr = NSLocalizedString("defaultError", comment: "")
            case HTTPCode.badRequest:
                errorStr = error.errorDTO?.message
            case HTTPCode.unauthorized:
                errorStr = NSLocalizedString("unauthorization", comment: "")
            case HTTPCode.notFound:
                errorStr = NSLocalizedString("Empty", comment: "")
            default:
                errorStr = NSLocalizedString("defaultError", comment: "")
            }
        } else {
            errorStr = NSLocalizedString("defaultError", comment: "")
        }
        
        return (httpCode, errorStr)
    }
    
}
