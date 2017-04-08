//
//  myUiScollView.swift
//  EKeeper
//
//  Created by limeng on 2017/4/7.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit

class myUIScrollView: UIScrollView, UIGestureRecognizerDelegate{

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (gestureRecognizer.state.rawValue != 0) {
//            return true
//        } else {
//            return false
//        }
        
        return (otherGestureRecognizer.view?.superview!.isKind(of: UITableView.self))!
    }
    
   
   // return [otherGestureRecognizer.view.superview isKindOfClass:[UITableView class]];
    
    
    
    
}
