//
//  UserData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/19.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class UserData: NSObject,NSCoding {

    var name:String?
    var tel:String?
    var headImgUrlStr:String?
    var email:String?
    var address:String?
    var birthDay:String?
    var count:Int = 0
    var idNum:String? //id
    var isLeave:Bool = false //是否请假
    var department:String?//部门
    var position:String?//职位
    var sex:String? //1男 2女
    var nickName:String?
    var token:String?
    var status:Int = 0 //账号状态 0：启用；1：禁用
    var level:String?//联系人列表请求的：用户级别
    var departmentId:Int = 0//部门ID，用于 存储时标识
    var levelId:Int = 0 //级别ID
    
    static func initWithUser(nUser user:User) -> UserData
    {
        let model = UserData()
        model.name = user.name
        model.tel = user.tel
        model.isLeave = user.isLeave
        model.departmentId = Int(user.departmentId)
        model.levelId = Int(user.levelId)
        if user.level != nil && !((user.level?.isEmpty)!) {
            model.position = user.level
        }
        if user.department != nil && !((user.department?.isEmpty)!) {
            model.department = user.department
        }
        if user.nickName != nil && !((user.nickName?.isEmpty)!) {
            model.nickName = user.nickName
        }
        if user.id != nil && !((user.id?.isEmpty)!) {
            model.idNum = user.id
        }
        if user.email != nil && !((user.email?.isEmpty)!) {
            model.email = user.email
        }
        if user.address != nil && !((user.address?.isEmpty)!) {
            model.address = user.address
        }
        if user.birthDay != nil && !((user.birthDay?.isEmpty)!) {
            model.birthDay = user.birthDay
        }
        if (user.headImg != nil) {
            model.headImgUrlStr = user.headImg
        }
        return model
    }
    
    class func createUserData(dic:Dictionary<String, Any>) -> UserData
    {
        let data = UserData()
        if dic.count != 0 {
            data.name = dic["name"] as! String?
            data.headImgUrlStr = dic["head_img"] as? String
            data.levelId = (dic["level_id"] as! NSNumber).intValue
            data.tel = dic["mobile"] as? String
            data.token = dic["token"] as? String
        }
        return data
    }
    
    //重写MJExtension方法，对应本地属性名和服务器字段名
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return [
            "tel":"mobile",
            "idNum":"id",
            "position":"level_name",
            "headImgUrlStr":"head_img",
            "nickName":"nickname",
            "levelId":"level_id",
            "departmentId":"department_id"
        ]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.tel, forKey: "tel")
        aCoder.encode(self.headImgUrlStr, forKey: "headImgUrlStr")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.birthDay, forKey: "birthDay")
        aCoder.encode(self.department, forKey: "department")
        aCoder.encode(self.position, forKey: "position")
        aCoder.encode(self.sex, forKey: "sex")
        aCoder.encode(self.nickName, forKey: "nickName")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.count, forKey: "count")
        aCoder.encode(self.idNum, forKey: "idNum")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.isLeave, forKey: "isLeave")
        aCoder.encode(self.level, forKey: "level")
        aCoder.encode(self.levelId, forKey: "levelId")
        aCoder.encode(self.departmentId, forKey: "departmentId")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.name = aDecoder.decodeObject(forKey: "name") as! String?
        self.tel = aDecoder.decodeObject(forKey: "tel") as! String?
        self.headImgUrlStr = aDecoder.decodeObject(forKey: "headImgUrlStr") as! String?
        self.email = aDecoder.decodeObject(forKey: "email") as! String?
        self.address = aDecoder.decodeObject(forKey: "address") as! String?
        self.birthDay = aDecoder.decodeObject(forKey: "birthDay") as! String?
        self.department = aDecoder.decodeObject(forKey: "department") as! String?
        self.position = aDecoder.decodeObject(forKey: "position") as! String?
        self.sex = aDecoder.decodeObject(forKey: "sex") as! String?
        self.nickName = aDecoder.decodeObject(forKey: "nickName") as! String?
        self.token = aDecoder.decodeObject(forKey: "token") as! String?
        self.level = aDecoder.decodeObject(forKey: "level") as! String?
        self.count = Int(aDecoder.decodeCInt(forKey: "count"))
        self.idNum = aDecoder.decodeObject(forKey: "idNum") as! String?
        self.status = Int(aDecoder.decodeCInt(forKey: "status"))
        self.isLeave = aDecoder.decodeBool(forKey: "isLeave")
        self.levelId = Int(aDecoder.decodeCInt(forKey: "levelId"))
        self.departmentId = Int(aDecoder.decodeCInt(forKey: "departmentId"))
    }
    
    override init() {
        
    }
    
    //返回 数据保存路径
    func getFilePath() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return path.appendingPathComponent("contacts.data")
    }
}
