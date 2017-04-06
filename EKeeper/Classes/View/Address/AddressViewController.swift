//
//  HomeViewCV.swift
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation

class AddressViewController: KeeperBaseViewController{
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
        
       
        
        
        let v2 = MessageTopCell.newInstance()!  as MessageTopCell
        let headerFrame: CGRect = CGRect(x: 0 , y: NavigationH + FSCalendarStandardWeeklyPageHeight, width: ScreenWidth, height: 160)
        v2.frame = headerFrame
        view.addSubview(v2)

        
    }
}
