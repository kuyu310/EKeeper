//
//  CoreDataTools.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/13.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

enum DepartmentID:Int {
    case DongShi = 0,//董事部
    IOS = 1, //IOS 部
    PHP = 2, //php部
    QianDuan = 3, //前端 部
    Android = 4, // 安卓部
    CeShi = 5, //测试
    HR = 6, //人事部
    Background = 7 //后台 部
}

class CoreDataTools: NSObject {
    
}

class DepartmentData: NSObject {
    var name:String?
    var list:NSMutableArray?
    class func create() -> DepartmentData
    {
        let data = DepartmentData()
        data.list = NSMutableArray()
        return data
    }
}
///CoreData操作
let EntityName = "User"

//返回新的

//添加一条数据entity
func getEntity(Model data:UserData) ->User
{
    let entity = NSEntityDescription.insertNewObject(forEntityName: EntityName, into: appDelegate.managedObjectContext) as! User
    entity.name = data.name
    entity.tel = data.tel
    entity.id = data.idNum
    entity.departmentId = Int16(data.departmentId)
    entity.levelId = Int32(data.levelId)
    if data.level != nil && !((data.level?.isEmpty)!) {
        entity.level = data.level
    }
    if data.department != nil && !((data.department?.isEmpty)!) {
        entity.department = data.department
    }
    if data.email != nil && !((data.email?.isEmpty)!) {
        entity.email = data.email
    }
    if data.address != nil && !((data.address?.isEmpty)!) {
        entity.address = data.address
    }
    if data.birthDay != nil && !((data.birthDay?.isEmpty)!) {
        entity.birthDay = data.birthDay
    }
    if data.headImgUrlStr != nil && !((data.headImgUrlStr?.isEmpty)!){
          //内存问题，等接口，暂时不存头像
        entity.headImg = data.headImgUrlStr
    }
    return entity
}
func addCoreData(Model data:UserData)
{
    let _ = getEntity(Model: data)
    do
    {
        try appDelegate.managedObjectContext.save()
        print("向数据库中 添加成功 ~ ~ ")
        dataCenter.setFirstLaunch()
    }catch
    {
        print("向数据库中 添加失败！！")
    }
}
//添加多条数据
//参数:modelList   数组:  对象类型:UserData
func addCoreDataFromArray(ModelList modelList:NSArray)
{
    if !dataCenter.isFirstLaunch() {//只有在第一次启动请求下来的数据 才保存数据
        return
    }
    
    for conItem in modelList {
        let contact = conItem as! ContactData
        for userItem in contact.member! {
            let user = userItem as! UserData
            user.departmentId = contact.idNum
            user.department = contact.name
            addCoreData(Model: user)
        }
        
    }
}

//删除数据
//参数：conditionDic 条件字典，
func deleteCoreData(ConditionDic conditionDic:NSMutableDictionary)
{
    let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EntityName)
    //构建条件
    var condition = String()
    var i = 0  //多个条件时中间用逗号隔开
    for item in conditionDic {
        var key = (item.key as? String)!
        if i > 0 {
            key.insert(",", at: key.startIndex)
        }
        let value = (item.value as? String)!
        key.append("=\'\(value)\'")
        condition.append(key)
        i = i+1
    }
    let predicate = NSPredicate(format: condition, "")
    request.predicate = predicate
    do{
        //查询满足条件的联系人
        let resultsList = try appDelegate.managedObjectContext.fetch(request) as! [User] as NSArray
        if resultsList.count != 0 {
            appDelegate.managedObjectContext.delete(resultsList[0] as! NSManagedObject)
            try appDelegate.managedObjectContext.save()
            print("从数据库中删除成功~ ~")
        }else{
            print("从数据库中删除失败！ 没有符合条件的联系人！")
        }
    }catch{
        print("从数据库中删除失败！")
    }
}
//修改数据  
//参数：新数据model      where：条件  规定始终使用 tel 作为判断条件。
func updateDataWithCoreData(Model userData:UserData, Where condiArray:NSArray)
{
    let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EntityName)
    let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: EntityName, in: appDelegate.managedObjectContext)!
    var name = condiArray[0] as! String
    name.insert("\'", at: name.startIndex)
    name.append("\'")
    let condition1 = "name=\(name)"
    let tel = condiArray[1] as! String
    let condition2 = "tel=\(tel)"
    let predicate = NSPredicate(format: condition1, condition2,"")
    request.entity = entity
    request.predicate = predicate
    do{
        let userList = try appDelegate.managedObjectContext.fetch(request) as! [User] as NSArray
        if userList.count != 0 {
            let user = userList[0] as! User
            user.name = userData.name
            user.tel = userData.tel
            user.id = userData.idNum
            user.departmentId = Int16(userData.departmentId)
            user.levelId = Int32(userData.levelId)
            if userData.level != nil && !((userData.level?.isEmpty)!) {
                user.level = userData.level
            }
            if userData.department != nil && !((userData.department?.isEmpty)!) {
                user.department = userData.department
            }
            if userData.email != nil && !((userData.email?.isEmpty)!) {
                user.email = userData.email
            }
            if userData.address != nil && !((userData.address?.isEmpty)!) {
                user.address = userData.address
            }
            if userData.birthDay != nil && !((userData.birthDay?.isEmpty)!) {
                user.birthDay = userData.birthDay
            }
            if userData.headImgUrlStr != nil && !((userData.headImgUrlStr?.isEmpty)!) {
                user.headImg = userData.headImgUrlStr
            }
            try appDelegate.managedObjectContext.save()
            print("从数据库中修改成功 ~ ~")
        }else{
            print("从数据库中修改失败，没有符合条件的联系人！")
        }
    }catch{
        print("从数据库中修改失败 ~ ~")
    }
    
}
//读取数据
func getDataFromCoreData() -> NSMutableArray
{
    var dataSource = NSArray()
    let resultList = NSMutableArray()
    let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
    let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: appDelegate.managedObjectContext)
    request.entity = entity
    do{
        dataSource = try appDelegate.managedObjectContext.fetch(request) as! [User] as NSArray
        if dataSource.count == 0 {
            return resultList
        }
        //构造数组，以数组形式按照部门返回所有联系人
        let dongshiArr = DepartmentData.create()
        let iosArr = DepartmentData.create()
        let phpArr = DepartmentData.create()
        let qianduanArr = DepartmentData.create()
        let androidArr = DepartmentData.create()
        let ceshiArr = DepartmentData.create()
        let hrArr = DepartmentData.create()
        let bgArr = DepartmentData.create()
        for item in dataSource {
            let user = item as! User
            let data = UserData.initWithUser(nUser: user)
            switch data.departmentId {
            case DepartmentID.DongShi.rawValue:
                dongshiArr.list?.add(data)
                dongshiArr.name = data.department
                break
            case DepartmentID.IOS.rawValue:
                iosArr.list?.add(data)
                iosArr.name = data.department
                break
            case DepartmentID.PHP.rawValue:
                phpArr.list?.add(data)
                phpArr.name = data.department
                break
            case DepartmentID.QianDuan.rawValue:
                qianduanArr.list?.add(data)
                qianduanArr.name = data.department
                break
            case DepartmentID.Android.rawValue:
                androidArr.list?.add(data)
                androidArr.name = data.department
                break
            case DepartmentID.CeShi.rawValue:
                ceshiArr.list?.add(data)
                ceshiArr.name = data.department
                break
            case DepartmentID.HR.rawValue:
                hrArr.list?.add(data)
                hrArr.name = data.department
                break
            default:
                bgArr.list?.add(data)
                bgArr.name = data.department
                break
            }
        }
        if dongshiArr.list?.count != 0 {
            resultList.add(dongshiArr)
        }
        if iosArr.list?.count != 0 {
            resultList.add(iosArr)
        }
        if phpArr.list?.count != 0 {
            resultList.add(phpArr)
        }
        if qianduanArr.list?.count != 0 {
            resultList.add(qianduanArr)
        }
        if androidArr.list?.count != 0 {
            resultList.add(androidArr)
        }
        if ceshiArr.list?.count != 0 {
            resultList.add(ceshiArr)
        }
        if hrArr.list?.count != 0 {
            resultList.add(hrArr)
        }
        if bgArr.list?.count != 0 {
            resultList.add(bgArr)
        }       
       
        print("数据读取成功 ~ ~")
    }catch{
        print("get_coredata_fail!")
    }
    return resultList
}



//  -----------------------  测试部分  ----------------------------
//查询所有数据并输出
func printAllDataWithCoreData()
{
    let array = getDataFromCoreData()
    for item in array {
        let user = item as! UserData
        print("name=",user.name,"tel=",user.tel,"email=",user.email,"address=",user.address)
    }
}
