//
//  RCChatListViewController.swift
//  EKeeper
//
//  Created by limeng on 2017/4/7.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit

class RCChatListViewController: RCConversationListViewController,RCIMConnectionStatusDelegate,UIAlertViewDelegate {

    var index = 0

    let conversationVC = ConversationViewController()
    func  createDiscussion(DiscussionTital: String){
        
        
        RCIM.shared().createDiscussion(DiscussionTital, userIdList: ["111","222","333","444","555","666","777"], success: { (discussion) in
            
            
            let conversationVC = ConversationViewController()
            conversationVC.targetId = discussion?.discussionId
            
            print(conversationVC.targetId)
            
            conversationVC.conversationType = .ConversationType_DISCUSSION
            
            
            
            DispatchQueue.main.async{
                self.navigationController?.pushViewController(conversationVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }
            
            
        }) { (RCErrorCode) in
            
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let RCServer = RCServerManager.shareInstance
            
        RCServer.getUserInfo_FromNaviServer(withUserId: "111") { (userInfo) in
            
            RCServer.connectServer(userInfo: userInfo!) {
                
                let conversationTypes = [
                    
                    
                    RCConversationType.ConversationType_DISCUSSION.rawValue,
                    RCConversationType.ConversationType_CUSTOMERSERVICE.rawValue,
                    RCConversationType.ConversationType_SYSTEM.rawValue,
                    RCConversationType.ConversationType_PUBLICSERVICE.rawValue,
                    RCConversationType.ConversationType_PUSHSERVICE.rawValue
                    
                ]
                //MARK:设置会话类型 刷新会话列表
                self.setDisplayConversationTypes(conversationTypes)
                
                self.isShowNetworkIndicatorView = true
                self.showConnectingStatusOnNavigatorBar = true
                
                
                
                self.createDiscussion(DiscussionTital: "dfsdfs")
                
                
                self.refreshConversationTableViewIfNeeded()
                
                
                //如果有新消息等待接受，就等待全部接受好消息后更新UI
                NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCell(_:)), name: NSNotification.Name(rawValue: "RefreshConversationList"), object: nil)
                
//                self.setRightNavigationItemWithFrame(image: UIImage(named: "find_1")!, frame: CGRect(x: 10, y: 3.5, width: 21, height: 19.5))
                
                
            }
        }
        
        
        //自定义空会话的背景View。当会话列表为空时，将显示该View
        
        
//        let blankView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
//        
//        blankView.backgroundColor  = UIColor.flatTeal
//        self.emptyConversationView = blankView
        
    }
    
    func onRCIMConnectionStatusChanged(_ status :RCConnectionStatus) -> Void {
        
        if (status == RCConnectionStatus.ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
            
            
            print("你的账号在别的地方登陆，被迫下线")
            
        }
        
    }
    
    func refreshCell(_ notification: Notification)
    {
        
        self.refreshConversationTableViewIfNeeded()
    }
    
    
  
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        
        
        conversationVC.targetId = model.targetId
        
        conversationVC.conversationType = .ConversationType_DISCUSSION
        //        conversationVC.enableUnreadMessageIcon = true
        //        conversationVC.enableSaveNewPhotoToLocalSystem = true
        conversationVC.title = model.conversationTitle
//        self.navigationController?.pushViewController(conversationVC, animated: true)
//        self.tabBarController?.tabBar.isHidden = true
      
        //寻找父控制器
        let superVC = ReturnFatherObject(ViewC: self,target: MessageViewController.self)
        
        
        
        superVC.navigationController??.pushViewController(conversationVC, animated: true)
        print(model.conversationTitle)
        
        
        
        
        
    }

    
    //MARK: 将要呈现此View时展示tabbar
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.refreshConversationTableViewIfNeeded()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /**
     用于获取父亲控制器
     
     - parameter ViewC:  当前的控制器
     - parameter target: 要获取的父亲控制器的类型
     
     - returns: 返回父亲控制器
     */
    func ReturnFatherObject( ViewC:AnyObject ,target:AnyClass )-> AnyObject
    {
        
        var responser = ViewC.next
        var ExitResponer = true
        while(ExitResponer == true)
        {
            
            //print("类型为",responser?.classForCoder)
            if( responser??.classForCoder != target && responser != nil)
            {
                responser = responser!?.next
                
            }else{
                
                ExitResponer = false
            }
        }
        print(responser)
        
        //print(responser!.nextResponder()!.nextResponder())
        return responser!!
        
    }
    
    
   
}
