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
    import CoreData
    
    
    let appDelegate = application.delegate as! AppDelegate
    
    let application = UIApplication.shared
    
   @UIApplicationMain
    class AppDelegate: UIResponder,UNUserNotificationCenterDelegate, UIApplicationDelegate{
        
        var window: UIWindow?
        
//        持久化存贮协调器
// MARK: - Core Data stack
        lazy var applicationDocumentsDirectory: NSURL = {
            // The directory the application uses to store the Core Data store file. This code uses a directory named "com.enjoytouch.CoreDataDemo" in the application's documents Application Support directory.
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1] as NSURL
        }()
        lazy var managedObjectModel: NSManagedObjectModel = {
            // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
            let modelURL = Bundle.main.url(forResource: "AdressListWithSwift3", withExtension: "momd")!
            return NSManagedObjectModel(contentsOf: modelURL)!
        }()
        lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
            // Create the coordinator and store
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
            var failureReason = "There was an error creating or loading the application's saved data."
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            } catch {
                // Report any error we got.
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                
                dict[NSUnderlyingErrorKey] = error as NSError
                let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                abort()
            }
            
            return coordinator
        }()
        lazy var managedObjectContext: NSManagedObjectContext = {
            
            let coordinator = self.persistentStoreCoordinator
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        }()
        
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
           
            
            
            //1.设置应用额外设置 及 启动预操作(判断版本更新main.json）
            setupAdditions()
            //2.判断沙箱动作，更新UI
            
            loadAppInfo()
            //3，初始化融云
            //初始化融云服务
             RCServerManager.shareInstance.initRongClould()
            
           
            
            
            //4.初始化week框架
            
            //5. 初始化蓝牙模块
            
            //6. 设置通知中心\推送
            self.initPush()
            addNotification()
            //7.加载广告或欢迎页，初始化windowkey
            window = UIWindow()
            window?.backgroundColor = UIColor.white
//            window?.rootViewController = GesturePasswordViewController()
            window?.rootViewController = KeeperMainViewController()
            //8.异步从服务器加载应用程序信息(main.json)
            window?.makeKeyAndVisible()
         
//            全局扁平化颜色管理 --这里先屏蔽掉了，不是太好用，需要美工配合一点点搞才行
//            Chameleon.setGlobalThemeUsingPrimaryColor(.flatPlum,
//                                                      withSecondaryColor: .flatBlue,
//                                                      andContentStyle: .contrast)
            return true
        
        }
        
        
        
        //app将要入非活动状态时调用，在此期间，应用程序不接收消息或事件，比如来电话了；保存数据
        func applicationWillResignActive(application: UIApplication) {
            self.saveContext()
        }
        //app被推送到后台时调用，所以要设置后台继续运行，则在这个函数里面设置即可；保存数据
        func applicationDidEnterBackground(application: UIApplication) {
            self.saveContext()
        }
        
        //app将要退出是被调用，通常是用来保存数据和一些退出前的清理工作；保存数据
        func applicationWillTerminate(application: UIApplication) {
            self.saveContext()
        }
        
        
        
        
        
        
    }
    
//MARK:    推送类接口
    extension AppDelegate{
        
        //注册推送
        func initPush()
        {
            if (kSystemVersionNum_Greater_Than_Or_Equal_To_10) {
                // 使用 UNUserNotificationCenter 来管理通知
                let center = UNUserNotificationCenter.current()
                //监听回调事件
                center.delegate = self;
                
                //iOS 10 使用以下方法注册，才能得到授权
                center.requestAuthorization(options: [UNAuthorizationOptions.alert,UNAuthorizationOptions.badge], completionHandler: { (granted:Bool, error:Error?) -> Void in
                    if (granted) {
                        //点击允许
                        print("注册通知成功")
                        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
                        center.getNotificationSettings(completionHandler: { (settings:UNNotificationSettings) in
                            print("huoqu")
                        })
                    } else {
                        //点击不允许
                        print("注册通知失败")
                    }
                })
                UIApplication.shared.registerForRemoteNotifications()
                
            }
        }
        
        //本地推送
        func registerNotification(alerTime:Int) {
            
            // 使用 UNUserNotificationCenter 来管理通知
            let center = UNUserNotificationCenter.current()
            
            //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
            content.sound = UNNotificationSound.default()
            
            // 在 alertTime 后推送本地推送
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(alerTime), repeats: false)
            let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
            //添加推送成功后的处理！
            center.add(request) { (error:Error?) in
                let alert = UIAlertController(title: "本地通知", message: "成功添加推送", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
        
        //当推送注册成功时 系统会回调以下方法 会得到一个 deviceToken
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let token = String(data: deviceToken, encoding: .utf8)
            print("push_token = ",token)
            
        }
        //当推送注册失败时 系统会回调
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            
        }
        //当有消息推送到设备 并且点击消息启动app 时会回调 userInfo 就是服务器推送到客户端的数据
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
            
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
//    for  coredata
    extension AppDelegate {
        
        func saveContext () {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
        }

        
    }
    
    
    
