//
//  ContactDetailController.swift
//  AdressListWithSwift2
//
//  Created by caixiasun on 16/9/7.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class ContactDetailController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var headImgTapBtn: UIButton!
    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var departmentImg: UIImageView!
    @IBOutlet weak var levelImg: UIImageView!
    @IBOutlet weak var nickNameLab: UILabel!
    
    
    
    let cellIdentifier = "ContactDetailCell"
    var dataSource:NSDictionary?
    var userData:UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshContent(noti:)), name: NSNotification.Name(rawValue: kNotification_refresh_contact_detail_from_edit), object: nil)
        
        self.nameLab.text = userData?.name
        if userData?.headImgUrlStr != nil {
            self.headImg.sd_setImage(with: URL(string: (userData?.headImgUrlStr)!), placeholderImage: kHeadImgObj)
        }
        //设置部门职位 flagimg
        self.setFlagImg()
                
    }
    func refreshContent(noti:NSNotification)
    {
        self.nameLab.text = userData?.name
        if userData?.headImgUrlStr != nil {
            self.headImg.sd_setImage(with: URL(string: (userData?.headImgUrlStr)!), placeholderImage: kHeadImgObj)
        }
        let model = noti.userInfo?["model"] as! UserData
        self.userData = model
        self.tablView.reloadData()
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- init method
    func initSubviews()
    {
        self.initNaviBar()
        
        self.tablView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.tablView.sectionIndexTrackingBackgroundColor = ClearColor
        self.dataSource = NSDictionary()
        
        setCornerRadius(view: self.headImg, radius: kRadius_headImg_common)
        setBorder(view: self.headImg)
        setCornerRadius(view: self.headImgTapBtn, radius: kRadius_headImg_common)
    }
    func initNaviBar()
    {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = WhiteColor
        
        let editBtn = YTDrawButton(title: kTitle_edit_button, TitleColor: WhiteColor, FontSize: kFontSize_navigationBar_button, Target: self, Action: #selector(ContactDetailController.itemAction(sender:)))
        editBtn.tag = 1
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
    }
    
    //设置部门职位 flagimg
    func setFlagImg()
    {
        /*
         * 1://董事部  2://iOS  3://php  4://前段
         * 5://安卓   7://人事  8://后台  6：//测试
         */
        var departmentImageString:String = ""
        switch (userData?.departmentId)! {
        case 1:
            departmentImageString = "dongshibu.png"
            break
        case 2:
            departmentImageString = "ios.png"
            break
        case 3:
            departmentImageString = "php.png"
            break
        case 4:
            departmentImageString = "qianduan.png"
            break
        case 5:
            departmentImageString = "android.png"
            break
        case 6:
            departmentImageString = "test.png"
            break
        case 7:
            departmentImageString = "hr.png"
            break
        default:
            departmentImageString = "bg.png"
            break
        }
        self.departmentImg.image = UIImage(named: departmentImageString)
        
        /*
         * 1://经理  2://大神  3://程序员  4://人事
         * 5://测试
         */
        var levelImageString:String = ""
        switch (userData?.levelId)! {
        case 1:
            levelImageString = "jingli.png"
            break
        case 2:
            levelImageString = "dashen.png"
            break
        case 3:
            levelImageString = "coder.png"
            break
        case 4:
            levelImageString = "hr.png"
            break
        default:
            levelImageString = "test.png"
            break
        }
        self.levelImg.image = UIImage(named: levelImageString)
    }
    
    //MARK:- action method
    @IBAction func itemAction(sender:UIButton)
    {
        switch sender.tag {
        case 1:/// Edit
            if !dataCenter.isAlreadyLogin() {
                appDelegate.loadLoginVC()
                return
            }
            let vc = EditContactController()
            vc.userData = self.userData
            let controller = YTNavigationController(rootViewController: vc)
            controller.initNavigationBar()
            self.present(controller, animated: false, completion: nil)
            break
        case 2://点击头像,查看大图
            
            break
        default:
            break
        }
    }
    
    //MARK:- UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else{//发送信息 模块
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 50
        }
    }
    //设置区头背景色
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = ClearColor
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! ContactDetailCell
        cell.backgroundColor = ClearColor
        if indexPath.section == 0 {
            cell.telLab.isHidden = false
            switch indexPath.row {
            case 0:
                cell.titleLab.text = "电话号码"
                cell.telLab.text = self.userData?.tel
                break
            case 1:
                cell.titleLab.text = "电子邮件"
                cell.telLab.text = self.userData?.email
                break
            case 2:
                cell.titleLab.text = "出生日期"
                cell.telLab.text = self.userData?.birthDay
                break
            case 3:
                cell.titleLab.text = "家庭住址"
                cell.telLab.text = self.userData?.address
                break
            default:
                break
            }
        }else{
            cell.telLab.isHidden = true
            if indexPath.row == 0 {
                cell.titleLab.text = "发送信息"
                
            }else{
                cell.titleLab.text = "共享联系人"
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0://拨打电话
            let tel = "tel://" + (self.userData?.tel)!
            let url = URL(string: tel)
            if application.canOpenURL(url!) {
                application.open(url!)
            }
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


