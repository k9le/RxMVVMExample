//
//  Weather.swift
//  RxMVVMExample
//
//  Created by Vasiliy Fedotov on 10/02/2019.
//  Copyright © 2019 Vasiliy Fedotov. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var value: Double
    
    enum RootKeys: String, CodingKey {
        case latitude
        case longitude
        case currently
    }

    enum CurrentlyKeys: String, CodingKey {
        case timestamp = "time"
        case value = "temperature"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        
        let currentlyContainer = try container.nestedContainer(keyedBy: CurrentlyKeys.self, forKey: .currently)
        
        timestamp = try currentlyContainer.decode(Date.self, forKey: .timestamp)
        value = try currentlyContainer.decode(Double.self, forKey: .value)
    }
    
}
