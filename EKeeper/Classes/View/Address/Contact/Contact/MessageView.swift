//
//  MessageView.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/13.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

let message_w:CGFloat = 80.0

class MessageView: UIView {
    
    var _titleLab:UILabel?
    let _viewW:CGFloat = kScreenWidth-100
    var _loadingView:UIActivityIndicatorView?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: _viewW, height: 60))
        
        self.backgroundColor = MainColor
        self.alpha = 0.8
        self.isHidden = true
        setCornerRadius(view: self, radius: 15)
        setYTTop(obj: self, top: kScreenHeight*0.3)
        setYTCenterX(obj: self, x: kScreenWidth*0.5)
        
        _titleLab = UILabel()
        _titleLab?.numberOfLines = 0
        _titleLab?.textColor = WhiteColor
        _titleLab?.font = UIFont.systemFont(ofSize: 15)
        _titleLab?.textAlignment = .center
        self.addSubview(_titleLab!)
        
        _loadingView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        _loadingView?.isHidden = true
        self.addSubview(_loadingView!)
    }
    
    func setMessage(Message mess:String)
    {
        if mess.isEmpty
        {
            return ;
        }
        
        self.isHidden = false
        _loadingView?.isHidden = true
        _titleLab?.isHidden = false
        _titleLab?.text = mess
        let size = calculateSizeWithContent(content: mess, fontSize: 15, originW: _viewW, originH: kScreenHeight)
        setYTSize(obj: _titleLab!, size: size)
        setYTSize(obj: self, size: CGSize(width: size.width+30, height: size.height+30))
        setYTTop(obj: _titleLab!, top: 15)
        setYTLeft(obj: _titleLab!, left: 15)
        setYTTop(obj: self, top: kScreenHeight*0.3)
        setYTCenterX(obj: self, x: kScreenWidth*0.5)
    }
    func setMessage(Message mess:String, Duration duration:TimeInterval)
    {
        self.setMessage(Message: mess)
        perform(#selector(hideMessage), with: nil, afterDelay: duration)
    }
    func hideMessage()
    {
        if (_loadingView?.isAnimating)! {
            _loadingView?.stopAnimating()
            _loadingView?.isHidden = true
        }
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setMessageLoading()
    {
        _titleLab?.isHidden = true
        _loadingView?.isHidden = false
        self.isHidden = false
        setYTCenterX(obj: _loadingView!, x: message_w*0.5)
        setYTCenterY(obj: _loadingView!, y: message_w*0.5)
        _loadingView?.startAnimating()
        setYTSize(obj: self, size: CGSize(width: message_w, height: message_w))
        setYTTop(obj: self, top: kScreenHeight*0.3)
        setYTCenterX(obj: self, x: kScreenWidth*0.5)
    }
    func setMessageLoading(Duration duration:TimeInterval)
    {
        setMessageLoading()
        perform(#selector(hideMessage), with: nil, afterDelay: duration)
    }
}

//在视图上添加MessageView
func addMessageView(InView superView:UIView) -> MessageView
{
    let messageView = MessageView(frame: .zero)
    superView.addSubview(messageView)
    return messageView
}
