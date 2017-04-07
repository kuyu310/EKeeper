    //
    //  AppDelegate.swift
    //  EKeeper
    //
    //  Created by limeng on 2017/3/30.
    //  Copyright © 2017年 limeng. All rights reserved.

    
    import UIKit
    import UserNotifications
    import SVProgressHUD
    import ChameleonFramework
    
    @UIApplicationMain
    

    class AppDelegate: UIResponder, UIApplicationDelegate{
        
        var window: UIWindow?
        
        
       
        
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
           
            //1.设置应用额外设置 及 启动预操作(判断版本更新main.json）
            setupAdditions()
            //2.判断沙箱动作，更新UI
            
            loadAppInfo()
            //3，初始化融云
           
            
            
            //4.初始化week框架
            
            //5. 初始化蓝牙模块
            
            //6. 设置通知中心
            addNotification()
            //7.加载广告或欢迎页，初始化windowkey
            window = UIWindow()
            window?.backgroundColor = UIColor.white
            window?.rootViewController = KeeperMainViewController()
            //8.异步从服务器加载应用程序信息(main.json)
            window?.makeKeyAndVisible()
         
//            全局扁平化颜色管理 --这里先屏蔽掉了，不是太好用，需要美工配合一点点搞才行
//            Chameleon.setGlobalThemeUsingPrimaryColor(.flatPlum,
//                                                      withSecondaryColor: .flatBlue,
//                                                      andContentStyle: .contrast)
            return true
        
        }
        
    }
    
    
    // MARK: - 设置应用程序额外信息
    extension AppDelegate {
        
         func setupAdditions() {
            
            // 1. 设置 SVProguressHUD 最小解除时间
            SVProgressHUD.setMinimumDismissTimeInterval(1)
            // 2. 设置用户授权显示通知
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (success, error) in
                    print("授权 " + (success ? "成功" : "失败"))
                }
            } else {
                // 10.0 以下
                // 取得用户授权显示通知[上方的提示条/声音/BadgeNumber]
                let notifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(notifySettings)
            }
        }
    }
    //设置通知中心
    extension AppDelegate{
        
        fileprivate     func addNotification() {
            
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showLoginViewController(_:)), name: NSNotification.Name(rawValue: ADImageLoadSecussed), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showLoginViewController), name: NSNotification.Name(rawValue: ADImageLoadFail), object: nil)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showLoginViewController), name: NSNotification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMainTabbarControllerView(_:)), name: NSNotification.Name(rawValue: loginSuncessForMainTabbar), object: nil)
            
            
        }
        
        //登录页面
        
        func showLoginViewController(_ noti: Notification){

            window!.rootViewController = LoginViewController()
        }
        
        //进入主页面，在主页面里面区分登录状态与否，来区分正是页面和访客页面
        
        func showMainTabbarControllerView(_ noti: Notification){
            
            window?.rootViewController  = KeeperMainViewController()

        }

        
    }
    // MARK: - 从服务器加载应用程序信息
    extension AppDelegate {
        
        fileprivate func loadAppInfo() {
            // 1. 模拟异步
                DispatchQueue.global().async {
                    // 1> url
                    let url = Bundle.main.path(forResource: "main", ofType: "json")
                    
                    
                    // 2> data
                    let data = NSData(contentsOf: URL(fileURLWithPath: url!))
                    
                    // 3> 写入磁盘
                    
                    
                    let docDir = ActionedPath
                    let jsonPath = (docDir).appendingPathComponent("main.json")
                    
                    // 直接保存在沙盒，等待下一次程序启动使用！
                    data?.write(toFile: jsonPath, atomically: true)
                    
                    print("应用程序加载完毕 \(jsonPath)")
                }
            }
            
 
    }
    
    
    
