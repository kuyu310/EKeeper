//
//  MessageViewController
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation

class MessageViewController: KeeperBaseViewController,SnailCurtainViewDelegate,SnailQuickMaskPopupsDelegate{
    
    var popups = SnailQuickMaskPopups()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
        
        self.navItem.rightBarButtonItem = UIBarButtonItem(title: "菜单", style: .plain, target: self, action: #selector(popDownMenu))
       
    }
    func popDownMenu(){
        
        
       
        
        
        let v = UIView.qzoneCurtain() as! SnailCurtainView
        v.delegate = self
        
        popups = SnailQuickMaskPopups(maskStyle: MaskStyle.blackTranslucent, aView: v)
       
        popups.presentationStyle = PresentationStyle.top
        
        popups.delegate = self
        popups.present(animated: true, completion: nil)
        
    }
    
        
}
