//
//  GesturePasswordViewController.swift
//  EKeeper
//
//  Created by limeng on 2017/4/14.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit

class GesturePasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        
        AppLock.set(controller: self, success: { (controller) in
            print(controller.title as Any)
        })
//        AppLock.verify(controller: self, success: { (controller) in
//            print("success", controller.title as Any)
//        }, forget: { (controller) in
//            print("forget", controller.title as Any)
//        }, overrunTimes: { (controller) in
//            print("overrunTimes", controller.title as Any)
//        })
        
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
