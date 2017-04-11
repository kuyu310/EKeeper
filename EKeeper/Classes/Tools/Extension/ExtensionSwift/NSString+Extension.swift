//
//  NSString+Extension.swift
//  EKeeper
//
//  Created by limeng on 2017/4/10.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
extension String
{
    /// 判断是否是手机号
    func isPhoneNumber() -> Bool {
        let pattern = "^1[345789]\\d{9}$"
        return NSPredicate.init(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    
    /// 判断是否是邮政编码
    func isPostCode() -> Bool {
        let pattern = "^\\d{6}$"
        return NSPredicate.init(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
}
