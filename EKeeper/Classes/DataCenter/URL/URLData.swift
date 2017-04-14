//
//  URLData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/28.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class URLData: NSObject {
    var relativeUrl:String?//相对路径url
    var url:String?//绝对路径url
    class func createURLData(data:Dictionary<String,Any>) -> URLData
    {
        
        let urlData = URLData()
        if data.count == 0 {
            return urlData
        }
        urlData.relativeUrl = data["uri"] as! String?
        urlData.url = data["url"] as! String?
        return urlData
    }
}
