//
//  Calendar.swift
//  EKeeper
//
//  Created by limeng on 2017/4/5.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
class Calendar: UIView {
    
    
    // MARK:- 创建视图
    class func newInstance() -> Calendar? {
        let nibView = Bundle.main.loadNibNamed("Calendar", owner: nil, options: nil)
        if let view = nibView?.first as? Calendar {
            return view
        }
        return nil
    }
    
    
}
