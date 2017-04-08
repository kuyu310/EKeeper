//
//  ConversationViewController.swift
//  CloudIM
//
//  Created by 田子瑶 on 16/8/24.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class ConversationViewController: RCConversationViewController {

    var  DiscussionID :String?
    
    let conversation = RCConversationModel()
    
//  重载这个函数，获得回调事件中的userid
     override func  didTapCellPortrait(_ userId: String){
        
//        SVProgressHUD.showInfo(withStatus: "你点击了用户ID：" + userId)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.enableSaveNewPhotoToLocalSystem = true
        
        
        if (self.conversationType == RCConversationType.ConversationType_DISCUSSION) {
            
            RCIMClient.shared().getDiscussion(self.targetId, success: { (discussion) in
                if (discussion != nil && (discussion?.memberIdList.count)! > 0 ){
                    
                    if  (discussion?.memberIdList as! NSArray).contains(RCIMClient.shared().currentUserInfo.userId){
                        
                        
                        let userId = RCIMClient.shared().currentUserInfo.userId
//                        "你已经入由【"+ userId + "】发起的讨论组：成员有【" +
                        let userids =  String(describing: discussion?.memberIdList)
                        let arrayStr = "讨论组成员有：" + userids
                        print(arrayStr)
                        
                        self.DiscussionID = discussion?.discussionId
                       
                        
                        
                        //插入一个表明成员的消息进来，由创建者
                        
                         let warningMsg =
                            RCInformationNotificationMessage.notification(withMessage: arrayStr, extra: nil)
                        
                        let message = RCMessage.init(type: self.conversationType, targetId: self.targetId, direction: RCMessageDirection.MessageDirection_SEND, messageId: -1, content: warningMsg)
                        
//
                        self.appendAndDisplay(message)
                        
                        
                        
                       
                        
                        self.enableUnreadMessageIcon = true
                        
                       
                    }
                    
                    
                    
                    
                    
                    
                }
            }, error: { (status) in
                
            })
            
        }
        
        var imageFile = RCKitUtility.imageNamed("actionbar_file_icon", ofBundle: "RongCloud.bundle")
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: imageFile, title: "文件", tag: 1006)
        
        
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage(named: "plus-highlighted"), title: "页面", tag: 201)
        
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage(named: "plus-highlighted"), title: "视频", tag: 202)

        
        
        ///注册自定义测试消息Cell界面,新版本的自定义消息注册方法
      
//        self.register(RCDTestMessageCell.self, forMessageClass: RCDTestMessage.self)
//        
//        
//        self.register(WMVideoMessageCell.self, forMessageClass: WMVideoMessage.self)
        

        
        
        //允许@功能
        RCIM.shared().enableMessageMentioned = true
        
    }

 

    //功能面板点击事件的方法，通过tag区分点击到的哪个item

    
    
    func setRightNavigationItemWithFrame(image: UIImage ,frame: CGRect) {
        
//        let rightBtn = RCDUIBarButtonItem.init(contain: image, imageViewFrame: frame, buttonTitle: nil, titleColor: nil, titleFrame: CGRect.zero, buttonFrame: CGRect(x: 0, y: 0, width: 25, height: 25), target: self, action: Selector("rightBarButtonItemClicked"))
//        
//        
//        self.navigationItem.rightBarButtonItem = rightBtn;
        
        
        
    }

    
    
   
    
   
    /*!
     自定义消息Cell显示的回调
     
     @param collectionView  当前CollectionView
     @param indexPath       该Cell对应的消息Cell数据模型在数据源中的索引值
     @return                自定义消息需要显示的Cell
     
     @discussion 自定义消息如果需要显示，则必须先通过RCIM的registerMessageType:注册该自定义消息类型，
     并在会话页面中通过registerClass:forCellWithReuseIdentifier:注册该自定义消息的Cell，否则将此回调将不会被调用。
     */
    
//    override func rcConversationCollectionView(_ collectionView: UICollectionView!, cellForItemAt indexPath: IndexPath!) -> RCMessageBaseCell! {
//        
//        let model = self.conversationDataRepository[indexPath.row] as! RCMessageModel
//        
//        let cellIndentifier = "TestMessageCell"
//        
//        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellIndentifier, for: indexPath) as! RCMessageBaseCell
//        
//        
//        
//        cell.setDataModel(model)
//        
//        return cell
//    }
//    
//    override func rcConversationCollectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
//         return CGSize(width: 300, height: 60)
//    }
//委托
    

   
    
    func rightBarButtonItemClicked() {
        
//        let announcementMsg = RCDTestMessage(content: "nihao,wo lai wan")
//        
//        announcementMsg?.mentionedInfo = RCMentionedInfo(mentionedType: RCMentionedType.mentioned_All, userIdList: nil, mentionedContent: nil)
//        
//        
//        RCIM.shared().sendMessage(RCConversationType.ConversationType_DISCUSSION, targetId: DiscussionID, content: announcementMsg, pushContent: nil, pushData: nil, success: { (Int) in
//        
//            print("success")
//        
//        }) { (RCErrorCode, Int) in
//
//            print("fails")
//        }
//   
        
        
        
//
//        let announcementMsg = WMVideoMessage(content: "nihao")
//        
//        announcementMsg?.mentionedInfo = RCMentionedInfo(mentionedType: RCMentionedType.mentioned_All, userIdList: nil, mentionedContent: nil)
//        
//        
//        RCIM.shared().sendMessage(RCConversationType.ConversationType_DISCUSSION, targetId: DiscussionID, content: announcementMsg, pushContent: nil, pushData: nil, success: { (Int) in
//            
//            print("success")
//            
//        }) { (RCErrorCode, Int) in
//            
//            print("fails")
//        }
//
        
        
        
    }
    

 
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
