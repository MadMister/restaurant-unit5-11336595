//
//  IntermediaryModels.swift
//  restaurant
//
//  Created by Jan Marten Sevenster on 08/03/2018.
//  Copyright © 2018 John Appleseed. All rights reserved.
//

import Foundation

struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
// more structs
