//
//  LeaveListResultData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/20.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class LeaveListResultData: NSObject {
    var data:NSMutableArray?
    var status:String?
    var total:Int = 0
    
    class func createContactResultData() -> LeaveListResultData
    {
        let returnData = LeaveListResultData()
        returnData.data = NSMutableArray()
        return returnData
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return [
            "data":"LeaveListData"
        ]
    }
}
