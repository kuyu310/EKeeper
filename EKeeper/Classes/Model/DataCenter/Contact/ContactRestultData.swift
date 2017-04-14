//
//  ContactRestultData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/20.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class ContactRestultData: NSObject {
    var data:NSMutableArray?
    var status:String?
    var total:Int = 0
    
    class func createContactResultData() -> ContactRestultData
    {
        let contact = ContactRestultData()
        contact.data = NSMutableArray()
        return contact
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return [
            "data":"ContactData"
        ]
    }
}
