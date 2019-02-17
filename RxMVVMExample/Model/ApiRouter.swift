//
//  ApiRouter.swift
//  RxMVVMExample
//
//  Created by Vasiliy Fedotov on 10/02/2019.
//  Copyright © 2019 Vasiliy Fedotov. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let locationiqKey : String = "e7a44bd9dd12e0"
fileprivate let darkskyKey : String = "726854db657182e495c8795cc2974f8e"

enum ApiRouter: URLRequestConvertible {
    
    case getCoordinatesOfPlace(place: String)
    case getTemperatureOfPlace(latitude: String, longitude: String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getCoordinatesOfPlace:
            return .get
        case .getTemperatureOfPlace:
            return .get
        }
    }
    
    var site: String {
        switch self {
        case .getCoordinatesOfPlace:
            return "https://eu1.locationiq.com/"
        case .getTemperatureOfPlace:
            return "https://api.darksky.net/forecast/"
        }
    }
    
    var path: String {
        switch self {
        case .getCoordinatesOfPlace:
            return "v1/search.php"
        case .getTemperatureOfPlace(let latitude, let longitude):
            return "\(darkskyKey)/\(latitude),\(longitude)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let URL = Foundation.URL(string: site)!
        var mutableURLRequest = URLRequest(url: URL.appendingPathComponent(path))
        mutableURLRequest.timeoutInterval = 10.0
        mutableURLRequest.httpMethod = method.rawValue
        
        switch self {
        case .getCoordinatesOfPlace(let place):
            let parameters: [String: AnyObject] = [ "key" : locationiqKey, "q" : place, "format" : "json", ] as [String: AnyObject]
            mutableURLRequest = try Alamofire.URLEncoding.queryString.encode(mutableURLRequest, with: parameters)
        case .getTemperatureOfPlace:
            let parameters: [String: AnyObject] = [ "exclude" : "minutely,hourly,daily,alerts,flags", "units" : "si"] as [String: AnyObject]
            mutableURLRequest = try Alamofire.URLEncoding.queryString.encode(mutableURLRequest, with: parameters)
        }
        
        return mutableURLRequest
    }
    
}
