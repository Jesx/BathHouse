//
//  BeverageData.swift
//  BathHouse
//
//  Created by 黃士軒 on 2019/11/19.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

struct BeverageItems: Codable {
    
    let data: [BeverageData]
    
    struct BeverageData: Codable {
        
        let id: Int
        let drink_name: String
        
    }
    
}

struct BuyDrinkInformation: Codable {
    
    let user_name: String
    let drink_id: Int
}
