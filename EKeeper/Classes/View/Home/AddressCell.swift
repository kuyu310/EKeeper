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
        //setupIndicatorView()
        
//        imageLabel.layer.cornerRadius = 10
      
        
        imageLabel.layer.cornerRadius = imageLabel.frame.size.width/2
        imageLabel.layer.masksToBounds = true
    }
    
    func setupIndicatorView() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = tintColor
        indicatorView.backgroundColor = .clear
        contentView.addSubview(indicatorView)
        
        let size: CGFloat = 12
        indicatorView.widthAnchor.constraint(equalToConstant: size).isActive = true
        indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
//        indicatorView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
    }
    

}
