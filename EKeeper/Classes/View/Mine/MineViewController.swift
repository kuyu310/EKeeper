//
//  HomeViewCV.swift
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation

class MineViewController: KeeperBaseViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
        
        let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 120, height: 50))
        bt.setTitle("设置手势密码", for: UIControlState())
        bt.backgroundColor = UIColor.flatSand
               bt.addTarget(self, action: #selector(sugsturePassword), for: .touchUpInside)
        
       
        
        let bt2 = UIButton(frame: CGRect(x: 100, y: 200, width: 120, height: 50))
        bt2.setTitle("验证手势密码", for: UIControlState())
        
        bt2.backgroundColor = UIColor.flatBlueDark
        bt2.addTarget(self, action: #selector(sugsturePassword2), for: .touchUpInside)
        
        self.view.addSubview(bt)
        self.view.addSubview(bt2)
        
        
    }
    
    func sugsturePassword(){
        
        AppLock.set(controller: self, success: { (controller) in
            print(controller.title as Any)
        })

        
    }
    
    
    func sugsturePassword2(){
        
        AppLock.verify(controller: self, success: { (controller) in
            print("success", controller.title as Any)
        }, forget: { (controller) in
            print("forget", controller.title as Any)
        }, overrunTimes: { (controller) in
            print("overrunTimes", controller.title as Any)
        })
        
    }

    
    
    
    
    
    
}
