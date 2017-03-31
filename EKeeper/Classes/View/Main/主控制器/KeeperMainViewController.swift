//
//  KeeperMainViewController.swift
//  limeng

//

import UIKit
import SVProgressHUD

/// 主控制器
class KeeperMainViewController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //给tabbar加载由navigation包裹的自控制器viewcontrollers
        setupChildControllers()
        //设置tabbar的UI和回调函数
        setTabbarUI()
        
    }
    
    
}

//MARK: 设置tabbar的ui
extension KeeperMainViewController{
    
    fileprivate func setTabbarUI(){
        
        tabBar.shadowImage = UIImage(named: "transparent")
        tabBar.backgroundImage = UIImage(named: "background_dark")
        self.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        
        self.didHijackHandler = {
            
            [weak tabBarController] tabbarController, viewController, index in
            
            print("执行闭包")
            
        }
        
    }
    
    
}
// extension 类似于 OC 中的 分类，在 Swift 中还可以用来切分代码块
// 可以把相近功能的函数，放在一个 extension 中
// 便于代码维护
// 注意：和 OC 的分类一样，extension 中不能定义属性
// MARK: - 设置界面
extension KeeperMainViewController {
    /// 设置所有子控制器
    fileprivate func setupChildControllers() {
        

        let v1 = MessageViewController()
        let v2 = MessageViewController()
        let v3 = MessageViewController()
        let v4 = MessageViewController()
        let v5 = MessageViewController()
        
        v1.navItem.leftBarButtonItem  = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        
        v1.navItem.rightBarButtonItem  = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))


        v2.navItem.leftBarButtonItem =  UIBarButtonItem(title: "注册2", style: .plain, target: self, action: #selector(register))
        
        v2.navItem.rightBarButtonItem  = UIBarButtonItem(title: "登录2", style: .plain, target: self, action: #selector(login))
        
        v4.navItem.leftBarButtonItem =  UIBarButtonItem(title: "注册4", style: .plain, target: self, action: #selector(register))
        
        v4.navItem.rightBarButtonItem  = UIBarButtonItem(title: "登录4", style: .plain, target: self, action: #selector(login))
        
        v5.navItem.leftBarButtonItem =  UIBarButtonItem(title: "注册5", style: .plain, target: self, action: #selector(register))
        
        v5.navItem.rightBarButtonItem  = UIBarButtonItem(title: "登录5", style: .plain, target: self, action: #selector(login))
        

        
        
        
        let nv1 = KeeperNavigationController.init(rootViewController:v1)
        let nv2 = KeeperNavigationController.init(rootViewController:v2)
        
        let nv4 = KeeperNavigationController.init(rootViewController:v4)
        
        let nv5 = KeeperNavigationController.init(rootViewController:v5)

        
        

  
        nv1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "消息", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        nv2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "通讯录", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        nv4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "应用", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        nv5.tabBarItem = ESTabBarItem.init(ExampleTipsContentView(), title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        

        
        // 设置 tabBar 的子控制器
        viewControllers = [nv1,nv2,v3,nv4,nv5]
        
    }
    
    func  login(){
        
        print("登录")
    }
    func  register(){
        
        print("注册")
    }

}
