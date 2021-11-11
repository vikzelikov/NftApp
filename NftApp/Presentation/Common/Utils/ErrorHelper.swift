//
//  ErrorHelper.swift
//  NftApp
//
//  Created by Yegor on 29.09.2021.
//

import Foundation

struct ErrorHelper {
    
    static func validateError(error: Error) -> (Int, String?) {
        var httpCode: Int = HttpCode.badRequest
        var errorStr: String? = nil
        
        if let error = error as? ErrorMessage, let code = error.code {
            
            httpCode = code

            switch code {
            case let c where c >= HttpCode.internalServerError:
                errorStr = NSLocalizedString("defaultError", comment: "")
                break
            case HttpCode.badRequest:
                errorStr = error.errorDTO?.message
                break
            case HttpCode.unauthorized:
                errorStr = NSLocalizedString("unauthorization", comment: "")
                break
            case HttpCode.notFound:
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
