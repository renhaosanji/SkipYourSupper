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
 dynamic var money = ""
 dynamic var sno=0;
 dynamic var date=""
 dynamic var food=""
 dynamic var type=""
 dynamic var calorie=""
    override static func primaryKey()->String?{
        return "date"
    }
    
}
