//
//  ContactController.swift
//  AdressListWithSwift2
//
//  Created by caixiasun on 16/9/7.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

let searchViewHeight:CGFloat = 45
let ContactCellHeight:CGFloat = 70
let ContactSectionHeight:CGFloat = 50

class ContactController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ContactModelDelegate {
    
    var searchView:UIView?
    var textField:UITextField?
    var searchLab:UILabel?
    var searchImg:UIImageView?
    var searchCoverView:UIView?
    
    var tableView:UITableView?
    var dataSource:NSMutableArray?
    var sectionArray:NSMutableArray?
    let cellReuseIdentifier = "AdressListCell"
    let headerIdentifier = "HeaderReuseIdentifier"
    var messageView:MessageView?
//    let contactModel:ContactModel = ContactModel()
    var localDataSource:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNaviBar()
        
        self.initSearchView()

        self.initSubviews()
        
        self.view.bringSubview(toFront: searchCoverView!)
        
        self.messageView = addMessageView(InView: self.view)
//        self.contactModel.delegate = self

        
        self.messageView?.setMessageLoading()
        
        
        
    }
    func refresh()
    {
        self.downpullRequest()
    }
   
       func downpullRequest() {
        //请求列表
//        self.contactModel.requestContactList()
    }
    
  
    
   
    
    func initSubviews()
    {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
                tableView.register(UINib(nibName: self.cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor =  UIColor.flatWhite
        self.view.addSubview(tableView)
        self.tableView = tableView;
        
    
        self.dataSource = NSMutableArray()
        self.localDataSource = NSMutableArray()
    }
 

    
    //MARK:- UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataSource?.count != 0 {
            return (self.dataSource?.count)!
        }else{
            return (self.localDataSource?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {       
        if dataSource?.count != 0 {
            let data = self.dataSource?.object(at: section) as! ContactData
            return data.name
        }else{
            let arr = self.localDataSource?.object(at: section) as! DepartmentData
            return arr.name
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UITableViewHeaderFooterView.init(reuseIdentifier: headerIdentifier)
        let view = UIView(frame:headView.bounds)
        headView.addSubview(view)
        return headView
    }
    //设置区脚背景色
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    //设置区头背景色
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.tintColor = UIColor(patternImage: UIImage(named: "navi_bg-2")!)
        header.layer.borderColor = MainColor.cgColor
        header.layer.borderWidth = 0.5
        header.textLabel?.textColor = WhiteColor
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ContactSectionHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.dataSource?.count != 0 {
            if section == (self.dataSource?.count)!-1 {
                return 49
            }
        }
        return 0
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContactCellHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource?.count == 0
        {
            return (self.localDataSource?.object(at: section) as! DepartmentData).list!.count
        }else{
            return ((self.dataSource?.object(at: section) as! ContactData).member?.count)!
        }
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! AdressListCell
        var data:UserData
        if self.dataSource?.count == 0 {
            data = (self.localDataSource?.object(at: indexPath.section) as! DepartmentData).list!.object(at: indexPath.row) as! UserData
        }else{
            data = (self.dataSource?.object(at: indexPath.section) as! ContactData).member?.object(at: indexPath.row) as! UserData
        }
        cell.backgroundColor = ClearColor
        cell.setContent(data: data)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ContactDetailController()
        controller.hidesBottomBarWhenPushed = true
        var data:UserData
        if self.dataSource?.count == 0 {
            data = (self.localDataSource?.object(at: indexPath.section) as! DepartmentData).list!.object(at: indexPath.row) as! UserData
        }else{
            data = (self.dataSource?.object(at: indexPath.section) as! ContactData).member?.object(at: indexPath.row) as! UserData
        }
        controller.userData = data
        self.navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath) as! AdressListCell
        weak var weakSelf = self
        let callAction = UITableViewRowAction(style: .normal, title: "拨打") { (action:UITableViewRowAction, indexPath:IndexPath) in
            weakSelf?.callAction(phone: cell.phone!)
        }
        callAction.backgroundColor = MainColor
        return [callAction]
    }
    
    //MARK: -UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) { 
            self.setSearchViewPosition()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.setSearchViewPosition()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: -ContactModelDelegate
    func requestContactListSucc(result: ContactRestultData) {
        self.messageView?.hideMessage()
        self.tableView?.stopLoading()
        if result.total == 0 {
        }else{
            //将列表存入coredata，记得卸载程序，抹掉假数据。
            self.dataSource = result.data
            self.tableView?.reloadData()
        }
        //将数据保存到本地
        addCoreDataFromArray(ModelList: result.data!)
    }
    func requestContactListFail(error: ErrorData) {
        self.messageView?.hideMessage()
        self.tableView?.stopLoading()
        self.messageView?.setMessage(Message: error.message!, Duration: 1)
        if error.code == kNetworkErrorCode {//网络连接问题，加载本地数据
            self.dataSource?.removeAllObjects()
            self.localDataSource = getDataFromCoreData()
            self.tableView?.reloadData()
        }
        
    }
}
