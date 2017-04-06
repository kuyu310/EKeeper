//
//  MessageTestView.swift
//  EKeeper
//
//  Created by limeng on 2017/4/5.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit

class MessageTestView: UIView {
    
    
    // MARK:- 创建视图
    class func newInstance() -> MessageTestView? {
        
        
        let nibView = Bundle.main.loadNibNamed("MessageTestView", owner: nil, options: nil)
        if let view = nibView?.first as? MessageTestView {
            return view
        }
        return nil
    }
    
    
}
