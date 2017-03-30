//
//  RCinterfacePackage.swift
//  EKeeper
//  融云结构的封装
//主要包括两大部分：
//  1.与本地服务器通讯的相关方法：取token，取群组关系，取用户数据源等
//  2.与融云服务区器的交互：token登录，api调用等
//  Created by 李萌 on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation

class RCclientInterfaceFunction:  NSObject  {
    
    
    
    
}
//MARK: - 初始化融云服务器,并实现融云的委托
extension RCclientInterfaceFunction: RCIMReceiveMessageDelegate,RCIMUserInfoDataSource{
    /*!
     获取用户信息
     
     @param userId      用户ID
     @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
     
     @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
     在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
     */
    public func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        print("获取用户信息")
    }
    
    /*!
     接收消息的回调方法
     
     @param message     当前接收到的消息
     @param left        还剩余的未接收的消息数，left>=0
     
     @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
     其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
     您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
     */
    public func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        print("接受消息的监听")
    }
    
    
    
    public func  initRongClould(){
        
        //MARK: 1.1查询userdefault中是否有Token
        //deviceToken是系统提供的，从苹果服务器获取的，用于APNs远程推送必须使用的设备唯一值。
        let deviceTokenCache = UserDefaults.standard.object(forKey: "kDeviceToken") as? String
        //MARK: 1.2初始化Appkey
        RCIM.shared().initWithAppKey(RONGCLOUD_IM_APPKEY)
        RCIMClient.shared().setDeviceToken(deviceTokenCache)
        //MARK: 3 设置用户信息提供者为自己--融云
        RCIM.shared().userInfoDataSource = self
        
        RCIM.shared().receiveMessageDelegate = self
        //开启输入状态监听
        
        RCIM.shared().enableTypingStatus = true
        //开启消息撤回功能
        
        RCIM.shared().enableMessageRecall = true
        
        //开启用户信息和群组信息的持久化
        RCIM.shared().enablePersistentUserInfoCache = true
        //开启发送已读回执
        RCIM.shared().enabledReadReceiptConversationTypeList = [RCConversationType.ConversationType_PRIVATE,RCConversationType.ConversationType_DISCUSSION,RCConversationType.ConversationType_GROUP]
        
        RCIM.shared().enableTypingStatus = true
        RCIM.shared().enableMessageAttachUserInfo = true;
        
        
        //注册
        //        RCIM.shared().registerMessageType(RCDTestMessage.self)
        //        RCIM.shared().registerMessageType(WMVideoMessage.self)
        
    }
    
    
}
