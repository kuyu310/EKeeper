//
//  WeexManager.swift
//  EKeeper
//
//  Created by limeng on 2017/4/11.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
//形成单例
class WeexManager: NSObject {
    
    
    
}

extension WeexManager{
    
   class func initWeex(){
        
        WXAppConfiguration.setAppGroup("授权棒银企管家")
        WXAppConfiguration.setAppName("授权棒银企管家")
        WXAppConfiguration.setAppVersion("1.0.0")
        
        WXLog.setLogLevel(WXLogLevel.all)
        
        // register event module
        WXSDKEngine.registerModule("event", with: NSClassFromString("WXEventModule"))
        
        // register handler，注册协议，这个协议是load image的协议，weex并没有实现远程图片加载，需要自己实现这个协议
        WXSDKEngine.registerHandler(WXImageLoaderDefaultImplement(), with:NSProtocolFromString("WXImgLoaderProtocol"))
        
        //init WeexSDK
        WXSDKEngine.initSDKEnvironment()
        // 注册地图组件，高德地图
        WXSDKEngine.registerComponent("map", with: WXMapComponent.self)

    }
    
    
    
}
