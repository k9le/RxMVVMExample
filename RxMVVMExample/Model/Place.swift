//
//  Place.swift
//  RxMVVMExample
//
//  Created by Vasiliy Fedotov on 10/02/2019.
//  Copyright © 2019 Vasiliy Fedotov. All rights reserved.
//

import Foundation

struct Place: Decodable {
    var fullName: String
    var latitude: String
    var longitude: String
    
    private enum CodingKeys: String, CodingKey {
        case fullName = "display_name"
        case latitude = "lat"
        case longitude = "lon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fullName = try container.decode(String.self, forKey: .fullName)
        
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
    }
    
}
