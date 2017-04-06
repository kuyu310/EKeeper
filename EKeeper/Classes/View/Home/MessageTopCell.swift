//
//  MessageTopCell.swift
//  EKeeper
//
//  Created by limeng on 2017/4/3.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit
import TTSegmentedControl
class MessageTopCell: UIView {

   
    // MARK:- 创建视图
    class func newInstance() -> MessageTopCell? {
        
//        var segmentedC1: TTSegmentedControl!
        let nibView = Bundle.main.loadNibNamed("MessageTopCell", owner: nil, options: nil)
        if let view = nibView?.first as? MessageTopCell {
          
            return view
        }
        return nil
    }


}
