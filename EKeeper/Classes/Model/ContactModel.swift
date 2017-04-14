//
//  ContactModel.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/20.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ContactModel: BaseModel {
    var delegate:ContactModelDelegate?
    
    ////获取联系人列表
    func requestContactList()
    {
       
        weak var blockSelf =  self
        let URLString = urlPrefix + "data.json"
//       let Parameter = [kToken:dataCenter.getToken() as Any]
        
        
//        Alamofire.request(URLString, method: .get,  parameters: nil, encoding: JSONEncoding.default).responseData {response in
        
        Alamofire.request(URLString).responseJSON {response in
            
            
            switch response.result.isSuccess{
                case true:
                if let value = response.result.value {
                   let json = JSON(value)
                   let status = json["status"].string
                    if status == "ok" {
                        let result = ContactRestultData.mj_object(withKeyValues: response.result.value)
                        //如果userdata解析不出来，则使用循环手动解析成userdata。
                        let coverResult = blockSelf?.covertDataToArray(data: result!)
                        self.delegate?.requestContactListSucc!(result: coverResult!)
                    }else{//请求失败  status=error
                        let errorObj = json["error"]
                        let data = ErrorData.initWithError(obj: errorObj)
                        self.delegate?.requestContactListFail!(error: data)
                    }

                }
                
            case false:
               print(response.result.error)
                
                
                
            }

            

        
    }
    

    }

    
    //将请求到的数据转换成对应的数据类型
    func covertDataToArray(data:ContactRestultData) -> ContactRestultData
    {
        let result = ContactRestultData.createContactResultData()
        result.total = data.total
        result.status = data.status
        
        for contact in (data.data)! {
            let covercontact = ContactData.mj_object(withKeyValues: contact) as ContactData
            let memberArray = NSMutableArray()
            for memeber in covercontact.member! {
                let coverMember = UserData.mj_object(withKeyValues: memeber) as UserData
                memberArray.add(coverMember)
            }
            covercontact.member = memberArray
            result.data?.add(covercontact)
        }
        
        return result
    }
}

@objc protocol ContactModelDelegate {
    @objc optional func requestContactListSucc(result:ContactRestultData)
    @objc optional func requestContactListFail(error:ErrorData)
    
    @objc optional func requestNewConatctSucc(success:SuccessData)
    @objc optional func requestNewConatctFail(error:ErrorData)
        
    @objc optional func requestEditContactSucc(success:SuccessData)
    @objc optional func requestEditContactFail(error:ErrorData)
    
    @objc optional func requestDeleteContactSucc()
    @objc optional func requestDeleteContactFail(error:ErrorData)
    
    @objc optional func requestUploadContactHeadImgFileSucc(result:URLData)
    @objc optional func requestUploadContactHeadImgFileFail(error:ErrorData)
}
