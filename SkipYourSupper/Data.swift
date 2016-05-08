//
//  Data.swift
//  DietWallet_ios
//
//  Created by RENHAO on 2016. 5. 8..
//  Copyright © 2016년 RENHAO. All rights reserved.
//

import Foundation
import RealmSwift
class Data: Object {
    var money = ""
   
 
    
    override static func primaryKey()->String?{
        return "money"
    }
    
}
