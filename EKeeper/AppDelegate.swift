//
//  AppDelegate.swift
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("n")
        return true
    }

}
// MARK: - 设置应用程序额外信息
extension AppDelegate {
    
    fileprivate func setupAdditions() {
        
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

