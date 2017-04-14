//
//  LeaveListData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/20.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class LeaveListData: NSObject {
    var started:String?
    var ended:String?
    var time:String?
    var name:String?
    var status:Int = 0//0:待审核;1:已通过;2:未通过;	
    var idNum:Int = 0
    var head_img:String?
    var created:String?
    var reason:String?
    var tel:String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return [
            "idNum":"id",
            "tel":"mobile"
        ]
    }
    
}
