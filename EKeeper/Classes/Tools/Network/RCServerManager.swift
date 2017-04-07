//
//  RCServerManager.swift
//  EKeeper
//
//  Created by limeng on 2017/4/7.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


//MARK: 临时的用户信息model
class userInfoTemp
{
    var userNick: String?
    
    var userToken: String?
    
    var userID: String?
    
    var userPicUrl: String?
    

}

class RCServerManager: NSObject {
        
    static let shareInstance: RCServerManager = {
        let RCtools = RCServerManager()
        return RCtools
    }()

    
}
extension RCServerManager: RCIMReceiveMessageDelegate,RCIMUserInfoDataSource{
    /*!
     接收消息的回调方法
     
     @param message     当前接收到的消息
     @param left        还剩余的未接收的消息数，left>=0
     
     @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
     其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
     您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
     */
    
    //MARK:融云的消息监听委托
    
    public func onRCIMReceive(_ message: RCMessage!, left: Int32) {
      
            print("reseive a message")
            
            if left == 0 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshConversationList"), object: nil)
                
                
            }
        }

    
//MARK: 连接融云的服务器
    func connectServer(userInfo: userInfoTemp, completion: @escaping ()-> Void) {
        var userToken: String = ""
        userToken = (userInfo.userToken)!
        //MARK: 1.3用Token测试连接
        RCIM.shared().connect(withToken: userToken, success: { (_) in
            //如果获取token由服务器完成，不要在app端做，太复杂了，客户端登录本地服务器成功后，服务器从融云获取token，传回客户端，客户端用这个token进行登录
            let currentUserInfo = RCUserInfo(userId:userInfo.userID , name: userInfo.userNick, portrait: userInfo.userPicUrl)
            RCIMClient.shared().currentUserInfo = currentUserInfo
            
            DispatchQueue.main.async(execute: {
                //MARK: 执行闭包
                completion()
            })
        }, error: { (_) in
            print("连接失败")
        }) {
            print("Token不正确或已失效")
            //            服务端加一个接口回来，让客户端再起请求本地服务向融云申请token        }
            
            
        }
    }
    
//MARK: 获取客户信息-- 从本地服务器获取token  数据是模拟的
    func getUserInfo_FromNaviServer(withUserId userId: String!, completion: ((userInfoTemp?) -> Void)!) {
        
        let userInfo = userInfoTemp()
        
        //        var json: JSON?
        userInfo.userID = userId
        
        
        Alamofire.request("http://ojjpkscxv.bkt.clouddn.com/tokenJsonLogin_pic").responseJSON{response in
            
            switch response.result.isSuccess {
                
            case true:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    switch userId {
                    case "111":
                        userInfo.userNick = "李萌"
                        userInfo.userToken = json["data"]["user"][0]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][0]["userPic"].string
                        print(userInfo.userToken)
                    case "222":
                        userInfo.userNick = "黄谦"
                        userInfo.userToken = json["data"]["user"][1]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][1]["userPic"].string
                    case "333":
                        userInfo.userNick = "沈树人"
                        userInfo.userToken = json["data"]["user"][2]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][2]["userPic"].string
                        
                    case "444":
                        userInfo.userNick = "金晨康"
                        userInfo.userToken = json["data"]["user"][3]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][3]["userPic"].string
                    case "555":
                        userInfo.userNick = "赵天田"
                        userInfo.userToken = json["data"]["user"][4]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][4]["userPic"].string
                        
                    case "666":
                        userInfo.userNick = "单露"
                        userInfo.userToken = json["data"]["user"][5]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][5]["userPic"].string
                        
                    case "777":
                        userInfo.userNick = "颜成杰"
                        userInfo.userToken = json["data"]["user"][6]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][6]["userPic"].string
                        
                        
                    default:
                        print("无此用户")
                    }
                    
                    return completion(userInfo)
                    
                    
                }
                
                
            case false:
                print(response.result.error)
            }
            
            
            
        }
        
        
        
    }
//MARK: 融云服务要求实现的委托代理，这个用户登录后的本地用户更新赋值用 。(数据是模拟的)
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!){
        
        let userInfo = RCUserInfo()
        Alamofire.request("http://ojjpkscxv.bkt.clouddn.com/tokenJsonLogin_pic").responseJSON{response in
            
            switch response.result.isSuccess {
                
            case true:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    switch userId {
                    case "111":
                        userInfo.name = "李萌"
                        userInfo.portraitUri = json["data"]["user"][0]["userPic"].string
                        
                    case "222":
                        userInfo.name = "黄谦"
                        userInfo.portraitUri = json["data"]["user"][1]["userPic"].string
                    case "333":
                        userInfo.name = "沈树人"
                        userInfo.portraitUri = json["data"]["user"][2]["userPic"].string
                        
                    case "444":
                        userInfo.name = "金晨康"
                        userInfo.portraitUri = json["data"]["user"][3]["userPic"].string
                    case "555":
                        userInfo.name = "赵天田"
                        userInfo.portraitUri = json["data"]["user"][4]["userPic"].string
                        
                    case "666":
                        userInfo.name = "单露"
                        userInfo.portraitUri = json["data"]["user"][5]["userPic"].string
                        
                    case "777":
                        userInfo.name = "颜成杰"
                        userInfo.portraitUri = json["data"]["user"][6]["userPic"].string
                        
                        
                    default:
                        print("无此用户")
                    }
                    
                    return completion(userInfo)
                    
                    
                }
                
                
            case false:
                print(response.result.error)
            }
            
            
        }
   
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
