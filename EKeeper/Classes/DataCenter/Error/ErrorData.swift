//
//  ErrorData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/19.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

let kNetworkErrorCode = "5555"

class ErrorData: NSObject {
    var message:String?
    var code:String?
    var error:String?
    class func initWithError(obj:Any?) -> ErrorData{
        let errorObj = obj as? Dictionary<String,Any>
        let errorData = ErrorData()
        if errorObj == nil {
            errorData.message = "未知错误！"
            errorData.code = kNetworkErrorCode
            return errorData
        }
        
        errorData.message = errorObj?["message"] as! String?
        errorData.code = errorObj?["code"] as! String?
        errorData.error = errorObj?["error"] as! String?
        return errorData
    }
}
