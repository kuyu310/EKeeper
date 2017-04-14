//
//  UserModel.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/12.
//  Copyright © 2016年 yatou. All rights reserved.
//



import UIKit
import Alamofire
import SwiftyJSON
class UserModel: BaseModel {
    var delegate:UserModelDelegate?
    
    /*****登录********/
    func requestLogin(Params params:Dictionary<String,Any>) {
        let URLString = urlPrefix + "/login"
        
         Alamofire.request(URLString, method: .get,  parameters: params, encoding: JSONEncoding.default).responseJSON {response in
           
            
            switch response.result.isSuccess{
            case true:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let status = json["status"].string
                    if status == "ok" {
                        let user = UserData().mj_setKeyValues(response.result.value)
                        self.delegate?.loginSucc!(userData: user!)
                    }else{//请求失败  status=error
                        let errorObj = response.result.error
                        let data = ErrorData.initWithError(obj: errorObj)
                        self.delegate?.loginFail!(error: data)
                    }
                }
                
            case false:
                print(response.result.error)
                
            }
            
            

        }
}
}
//用户数据模型声明两个委托到外面
@objc protocol UserModelDelegate {
    @objc optional func loginSucc(userData:UserData)
    @objc optional func loginFail(error:ErrorData)
}


