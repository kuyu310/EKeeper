//
//  DataCenter.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 2016/9/17.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

let kFirstLaunch = "isFirstLaunchKey"
let kIsLogin = "isLoginKey"
let kUserData = "UserDataKey"

// 数据处理中心
class DataCenter: AnyObject {
    //单例
    static let center:DataCenter = DataCenter()
    private init() {}
    
    var userdata_save_file_path = UserData().getFilePath()
     var dataCenter:NSMutableDictionary = NSMutableDictionary()
    func isFirstLaunch() -> Bool
    {
        let userDefault = UserDefaults.standard
        var isFirst:Bool = true
        let value = userDefault.object(forKey: kFirstLaunch)
        if value != nil && value as! Int == 1 {
            isFirst = false
        }
        return isFirst
    }
    func setFirstLaunch()
    {
        let userDefault = UserDefaults.standard
        userDefault.set(1, forKey: kFirstLaunch)
    }
    //判断用户是否已经登录
    func isAlreadyLogin() -> Bool
    {
        let userDefault = UserDefaults.standard
        var isFirst:Bool = false
        let value = userDefault.object(forKey: kIsLogin)
        if value != nil && value as! Int == 1 {
            isFirst = true
        }
        return isFirst
    }
    func setLogin()
    {
        let userDefault = UserDefaults.standard
        userDefault.set(1, forKey: kIsLogin)
    }
    //退出登录
    func setLoginout()
    {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: kIsLogin)
//        还要删除userData，
        userDefault.removeObject(forKey: kToken)
    }
    //保存用户数据
    func saveUserData(Data user:UserData)
    {
        NSKeyedArchiver.archiveRootObject(user, toFile: userdata_save_file_path)       
        
        setToken(token: user.token!)
        
    }
    //取出用户数据
    func getUserData() -> UserData
    {
        let data = NSKeyedUnarchiver.unarchiveObject(withFile: userdata_save_file_path) as! UserData
        return data
    }
    func setToken(token:String)
    {
        let userDefault = UserDefaults.standard
        userDefault.set(token, forKey: kToken)
    }
    func getToken() -> String
    {
        let userDefault = UserDefaults.standard
        return userDefault.object(forKey: kToken) as! String
    }
    //用户头像
    func setHeadImgUrlString(imageUrl:String)
    {
        let userDefault = UserDefaults.standard
        userDefault.set(imageUrl, forKey: kHeadImgUrl)
    }
    func getHeadImgUrlString() -> String
    {
        let userDefault = UserDefaults.standard
        let url:String? = userDefault.object(forKey: kHeadImgUrl) as? String
        if url == nil || (url?.isEmpty)! {
            return ""
        }
        return url!
    }
}
let dataCenter = DataCenter.center

//获取本地json数据
func getContactFromLocal() -> NSMutableArray
{
    var userList:NSMutableArray?
    let path = Bundle.main.path(forResource: "data", ofType: "json")
    let url = URL(fileURLWithPath: path!)
    do{
        let data = try Data(contentsOf: url)
        let json:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        let jsonDic = json as! Dictionary<String,Any>
        let datalist = jsonDic["data"] as! NSArray
        userList = UserData.mj_objectArray(withKeyValuesArray: datalist)
        if dataCenter.isFirstLaunch() { // 第一次启动 设置userDefaults  如果是第一次获取数据，则保存到本地
            dataCenter.setFirstLaunch()
            addCoreDataFromArray(ModelList: userList!)
        }
        
    }catch let erro as Error!{
        print("读取本地数据出现错误！",erro)
    }
    return userList!
}
