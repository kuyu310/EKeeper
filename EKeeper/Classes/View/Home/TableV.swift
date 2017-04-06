//
//  MessageHomeViewController.swift
//  EKeeper
//
//  Created by limeng on 2017/4/5.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit
import SJFluidSegmentedControl



class TableV:  UITableView{
    
   
    // MARK:- 创建视图
    class func newInstance() -> TableV? {
        let nibView = Bundle.main.loadNibNamed("TableV", owner: nil, options: nil)
        if let view = nibView?.first as? TableV {
            return view
        }
        return nil
    }

  
}
