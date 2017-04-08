//
//  WBNavigationController.swift
//  传智微博
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class KeeperNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 隐藏默认的 NavigationBar
        navigationBar.isHidden = true
    }
    
    /// 重写 push 方法，所有的 push 动作都会调用此方法！
    /// viewController 是被 push 的控制器，设置他的左侧的按钮作为返回按钮
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 如果不是栈底控制器才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0 {
            // 隐藏底部的 TabBar
            viewController.hidesBottomBarWhenPushed = true
            
//             判断控制器的类型
            if let vc = viewController as? KeeperBaseViewController {
                
                var title = "返回"
                
                // 判断控制器的级数，只有一个子控制器的时候，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    // title 显示首页的标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                // 取出自定义的 navItem，设置左侧按钮作为返回按钮
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(popToParent))
               
            }
            else
            {
                var title = "返回"
                
                // 判断控制器的级数，只有一个子控制器的时候，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    // title 显示首页的标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                navigationBar.isHidden = false
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(popToParent))
                
            }
            
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    
    /// POP 返回到上一级控制器
    @objc private func popToParent() {
        navigationBar.isHidden = true
        popViewController(animated: true)
    }
}
