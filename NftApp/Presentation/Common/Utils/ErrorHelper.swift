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
        var errorStr: String? = nil
        
        if let error = error as? ErrorMessage, let code = error.code {
            
            httpCode = code

            switch code {
            case let c where c >= HTTPCode.internalServerError:
                errorStr = NSLocalizedString("defaultError", comment: "")
                break
            case HTTPCode.badRequest:
                errorStr = error.errorDTO?.message
                break
            case HTTPCode.unauthorized:
                errorStr = NSLocalizedString("unauthorization", comment: "")
                break
            case HTTPCode.notFound:
                errorStr = NSLocalizedString("Empty", comment: "")
                break
            default:
                errorStr = NSLocalizedString("defaultError", comment: "")
            }
        } else {
            errorStr = NSLocalizedString("defaultError", comment: "")
        }
        
        return (httpCode, errorStr)
    }
    
}
