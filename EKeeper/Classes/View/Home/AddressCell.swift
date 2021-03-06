//
//  AddressCell.swift
//  EKeeper
//
//  Created by limeng on 2017/4/11.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
import SwipeCellKit
class AddressCell: SwipeTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var leverLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!

    @IBOutlet weak var imageLabel: UIImageView!
    
    var animator: Any?
    
    var indicatorView = IndicatorView(frame: .zero)
    
    
    
    override func awakeFromNib() {
        
        imageLabel.layer.cornerRadius = imageLabel.frame.size.width/2
        imageLabel.layer.masksToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
