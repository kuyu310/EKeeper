//
//  ContactData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/20.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class ContactData: NSObject {
    var name:String?
    var idNum:Int = 0 //id
    var number:Int = 0  //成员个数
    var member:NSMutableArray? = NSMutableArray()
    
    class func createContactData() -> ContactData
    {
        let contact = ContactData()
        contact.member = NSMutableArray()
        return contact
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return [
            "data":"UserData"
        ]
    }
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return [
            "idNum":"id"
        ]
    }
    
}
