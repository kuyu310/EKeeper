//
//  HomeViewCV.swift
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation

class WorksViewController: KeeperBaseViewController{
    
     var WeexInstance:WXSDKInstance?
     var url:URL?
     var weexView = UIView()
     var weexHeight:CGFloat?
     var top:CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.flatWhite
        WeexManager.initWeex()
       
        

        render()
        
    }
    
    deinit {
        if WeexInstance != nil {
            WeexInstance!.destroy()
        }
    }

    
    

}

//下面是weex的调用
extension WorksViewController {
    
    
    func render(){
        
        if WeexInstance != nil {
            WeexInstance!.destroy()
        }
        WeexInstance = WXSDKInstance();
        
        WeexInstance!.viewController = self
        let width = self.view.frame.size.width
        
        WeexInstance!.frame = CGRect(x: 0, y: NavigationH, width: width, height: self.view.frame.size.height)
        weak var weakSelf:WorksViewController? = self
        
        
        WeexInstance?.onCreate = {
            (view:UIView?)-> Void in
            weakSelf!.weexView.removeFromSuperview()
            weakSelf!.weexView = view!
            weakSelf!.view.addSubview(self.weexView)
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf!.weexView)
        }
        
        WeexInstance?.onFailed = {
            (error:Error?)-> Void in
            
            print("faild at error: %@", error!)
        }
        
        WeexInstance?.renderFinish = {
            (view:UIView?)-> Void in
            print("render finish")
        }
        WeexInstance?.updateFinish = {
            (view:UIView?)-> Void in
            print("update finish")
        }
        WeexInstance!.render(with: url!, options: ["bundleUrl":String.init(format: "file://%@/bundlejs/", Bundle.main.bundlePath)], data: nil)
       

    }
    
    
}
