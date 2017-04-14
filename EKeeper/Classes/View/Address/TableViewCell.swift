//
//  TableViewCell.swift
//  EKeeper
//
//  Created by limeng on 2017/4/12.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var leverLabel: UILabel!
    
    @IBOutlet weak var telLable: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    
    
    
    
    
    
    
//    在设计cell时多加了个view的好处很多，很多滑动操作变得更和谐了。也不知道为什么
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageLabel.layer.cornerRadius = imageLabel.frame.size.width/2
        imageLabel.layer.masksToBounds = true

        
    }

    
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
