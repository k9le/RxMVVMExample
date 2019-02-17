//
//  DataManager.swift
//  RxMVVMExample
//
//  Created by Vasiliy Fedotov on 10/02/2019.
//  Copyright © 2019 Vasiliy Fedotov. All rights reserved.
//

import Foundation
import Alamofire

class DataManager {
    
    static let shared: DataManager = DataManager()
    
    func getPlace(by string: String, completionBlock: @escaping (Place?, Bool, Error?) -> Void) {
        
        let URLRequest = ApiRouter.getCoordinatesOfPlace(place: string)
        
        Alamofire.request(URLRequest).responseData { (response) -> Void in
            switch response.result {
            case .success(let JSON):
                let place: [Place]? = try? JSONDecoder().decode([Place].self, from: JSON)
                completionBlock(place?.first ?? nil, true, nil)
            case .failure(let err):
                completionBlock(nil, false, err)
            }
        }
    }
    
    func getTemperature(inLat lat: String, lon: String, completionBlock: @escaping (Weather?, Bool, Error?) -> Void) {
        let URLRequest = ApiRouter.getTemperatureOfPlace(latitude: lat, longitude: lon)

        Alamofire.request(URLRequest).responseData { (response) -> Void in
            switch response.result {
            case .success(let JSON):
                let place: Weather? = try? JSONDecoder().decode(Weather.self, from: JSON)
                completionBlock(place, true, nil)
            case .failure(let err):
                completionBlock(nil, false, err)
            }
        }

    }
    
}
