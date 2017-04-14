//
//  UserModel.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/12.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit
import Alamofire
class UserModel: BaseModel {
    var delegate:UserModelDelegate?
    
    /*****登录********/
    func requestLogin(Params params:Dictionary<String,Any>) {
        let URLString = urlPrefix + "/login"
        
        
        let sets=NSSet()
        
        
        
         Alamofire.request(URLString, method: .get,  parameters: params, encoding: JSONEncoding.default).responseJSON {response in
            let dic = response.data as! Dictionary<String, Any>
            let status = dic["status"] as! String
            if status == "ok" {
                let user = UserData().mj_setKeyValues(dic["data"])
                self.delegate?.loginSucc!(userData: user!)
            }else{//请求失败  status=error
                let errorObj = dic["error"]
                let data = ErrorData.initWithError(obj: errorObj)
                self.delegate?.loginFail!(error: data)
            }
            
        }
    }
}

@objc protocol UserModelDelegate {
    @objc optional func loginSucc(userData:UserData)
    @objc optional func loginFail(error:ErrorData)
}


