//
//  MessageViewController
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation

class MessageViewController: KeeperBaseViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
        
        let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        bt.titleLabel?.text = "点我"
        bt.backgroundColor = UIColor.yellow
       
    }
}
