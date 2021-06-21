//
//  ApiError.swift
//  CenfoWebAPICaller
//
//  Created by user195672 on 6/20/21.
//

import Foundation

enum ApiError: Error{
    case requestFailed(description:String)
    case jsonConvertFailure(description:String)
    case invalidData
    case responseUnsuccessful(description:String)
    case jsonParsinFailure
    case noInternetConnection
    case serializationFailure
    case timeOut
    case autenticationFailure(description:String)
}
