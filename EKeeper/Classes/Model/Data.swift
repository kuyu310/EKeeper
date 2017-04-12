//
//  Data.swift
//
//  Created by Jeremy Koch
//  Copyright © 2017 Jeremy Koch. All rights reserved.
//

import Foundation



class AddressData {
    let avatar: String
    let level: String
    let name: String
    let phoneNumber: String
    let userid : String
    var unread = false
    
    init(avatar: String, level: String, name: String, phoneNumber: String,userid: String) {
        self.avatar = avatar
        self.level = level
        self.name = name
        self.phoneNumber = phoneNumber
        self.userid = userid
        
    }
    
 
}

let mockAddress: [AddressData] = [
 
    AddressData(avatar: "1", level: "部门主管", name: "李大爷", phoneNumber: "15558189696", userid: "23344564564645645456"),
    AddressData(avatar: "2", level: "二部研发工程师", name: "李四", phoneNumber: "13456761119", userid: "23344564564645645456"),
    AddressData(avatar: "3", level: "财物总监", name: "王五和", phoneNumber: "12345678921", userid: "23344564564645645456"),
    AddressData(avatar: "4", level: "财物助理", name: "赵六中", phoneNumber: "12345678921", userid: "23344564564645645456"),
    AddressData(avatar: "5", level: "办公行政采购员", name: "小李", phoneNumber: "12345678921", userid: "23344564564645645456"),
    AddressData(avatar: "1", level: "原料采购", name: "小王大爷", phoneNumber: "12345678921", userid: "23344564564645645456"),
    AddressData(avatar: "2", level: "华北区销售总监", name: "猪小妹", phoneNumber: "12345678921", userid: "23344564564645645456"),
    AddressData(avatar: "3", level: "办公室主任", name: "小金", phoneNumber: "12345678921", userid: "23344564564645645456"),
    AddressData(avatar: "4", level: "销售部总经理", name: "小沈", phoneNumber: "12345678921", userid: "23344564564645645456"),
    AddressData(avatar: "5", level: "董事长", name: "小刘", phoneNumber: "12345678921", userid: "23344564564645645456")
   
   
]

