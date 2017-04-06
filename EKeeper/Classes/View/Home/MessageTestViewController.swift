//
//  MessageTestViewController.swift
//  EKeeper
//
//  Created by limeng on 2017/4/5.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit
import SJFluidSegmentedControl
class MessageTestViewController: KeeperBaseViewController {
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v1 = MessageTestView.newInstance()! as MessageTestView
        
        view.addSubview(v1)
//        self.calendar.select(Date())
//        
//        self.view.addGestureRecognizer(self.scopeGesture)
//        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
//        self.calendar.scope = .week
//        
//        // For UITest
//        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    
    
    
    
}
