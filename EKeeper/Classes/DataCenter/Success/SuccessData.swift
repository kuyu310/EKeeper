//
//  SuccessData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/20.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class SuccessData: NSObject {
    var success:String?
    var message:String?
    
    class func initData() -> SuccessData{
        let succData = SuccessData()
        succData.message = "添加成功！"
        return succData
    }
}
