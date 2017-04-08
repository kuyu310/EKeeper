//
//  MessageViewController
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
//import SJFluidSegmentedControl
import TTSegmentedControl
import UIKit
import PullToRefresh


class MessageViewController: KeeperBaseViewController,SnailCurtainViewDelegate,SnailQuickMaskPopupsDelegate,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance,UIGestureRecognizerDelegate{
    
    
    
    
    
//    var tableView :UITableView!
    var Person : MessageTopCell!
    fileprivate weak var calendar: FSCalendar!
    var scrollContainer: myUIScrollView!
    
    var tableView1: UITableView!
//    var tableView2: UITableView!
    var tableView3: UITableView!
    
    var historyY:CGFloat = 0.0
    
    var segmentView:TransitionSegmentView?
//    这个放到全局里面，他所属的控制器才能看到这个，响应他的事件
    let RCListVC = RCChatListViewController()
    
    fileprivate var dataSourceCount = 12
    //MARK:模拟数据
    var allnames: Dictionary<Int, [String]>?
    var adHeaders: [String]?
    
    var allnames3: Dictionary<Int, [String]>?
    var adHeaders3: [String]?

    
    
    
    //初始化数据，这一次数据，我们放在属性列表文件里
    
    
    var baby = ["沈先生发起了一个任务",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "打款审批",
                "打款审批",
                "打款审批",
                "打款审批",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "打款审批",
                "打款审批",
                "打款审批",
                "打款审批",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "打款审批",
                "打款审批",
                "打款审批",
                "打款审批",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "打款审批",
                "打款审批",
                "打款审批",
                "打款审批",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "打款审批",
                "打款审批",
                "打款审批",
                "打款审批",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "资金调拨申请",
                "打款审批",
                "请假审批",
                "物品领用申请",
                "打款审批",
                "打款审批",
                "打款审批",
                "打款审批",
                "打款审批"]
    
    var babyImage = ["sina_点评","sina_好友圈","sina_更多","sina_点评","sina_点评",
                     "sina_好友圈","sina_好友圈","sina_好友圈","sina_好友圈","sina_更多","sina_更多","sina_好友圈",
                     "sina_点评","sina_好友圈","sina_好友圈","sina_更多","sina_点评","sina_点评",
                     "sina_好友圈","sina_好友圈","sina_好友圈","sina_好友圈","sina_更多","sina_更多","sina_好友圈",
                     "sina_点评","sina_好友圈"
        ,"sina_好友圈","sina_更多","sina_点评","sina_点评",
         "sina_好友圈","sina_好友圈","sina_好友圈","sina_好友圈","sina_更多","sina_更多","sina_好友圈",
         "sina_点评","sina_好友圈","sina_好友圈","sina_更多","sina_点评","sina_点评",
         "sina_好友圈","sina_好友圈","sina_好友圈","sina_好友圈","sina_更多","sina_更多","sina_好友圈",
         "sina_点评","sina_好友圈","sina_好友圈","sina_更多","sina_点评","sina_点评",
         "sina_好友圈","sina_好友圈","sina_好友圈","sina_好友圈","sina_更多","sina_更多","sina_好友圈",
         "sina_点评","sina_好友圈"]
    

    
    var popups = SnailQuickMaskPopups()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
  //test
    fileprivate func initDataForTest(){
        
        
        self.allnames = [
            0:[String] ([
                "合同申请大同银行",
                "工控机采购流程",
                "用章申请"]),
            1:[String]([
                "请假申请",
                "业务流程修正",
                "病假"])
        ]
        
        self.adHeaders = [
            "工作流",
            "日常事务审批"
        ]
        
        self.allnames3 = [
            0:[String] ([
                "合同申请大同银行33",
                "工控机采购流程333",
                "用章申请333"]),
            1:[String]([
                "请假申请33",
                "业务流程修正33",
                "病假33"])
        ]
        
        self.adHeaders3 = [
            "工作流33",
            "日常事务审批33"
        ]

        
        

    }
    
    //MARK: 手势设置，懒加载模式
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        //表示最小手指数量，默认值为1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    //MARK: 配置分段按钮栏 limeng
    func configSegment()  {
        let titles:[String] = ["工作任务","我的日程","我的消息"]
        let rect = CGRect(x:0,y:64,width:ScreenWidth,height:35)
        let configure = SegmentConfigure(textSelColor:UIColor.flatWhite, highlightColor:UIColor.flatSandDark,titles:titles)
        segmentView = TransitionSegmentView.init(frame: rect, configure: configure)

        ///segment的label被点击时调用
        segmentView?.setScrollClosure(tempClosure: { (index) in
            
            let point = CGPoint(x:CGFloat(index)*ScreenWidth,y:0)
            self.scrollContainer?.setContentOffset(point, animated: true)
            
        })
        
      
        
    }
    //MARK:配置scroll视图容器
    func configScrollView()  {
        //scrollview容器
        let scrollViewframe: CGRect = CGRect(x: 0 , y: NavigationH + FSCalendarStandardWeeklyPageHeight, width: ScreenWidth, height: 500)
        
        scrollContainer = myUIScrollView.init(frame: scrollViewframe)
        
        
        //初始化融云的chatlist
        
        let tableView1Frame: CGRect = CGRect(x: CGFloat(0)*ScreenWidth,y:0,width:(scrollContainer?.bounds.width)!,height:(scrollContainer?.bounds.height)!)
        let tableView2Frame: CGRect = CGRect(x: CGFloat(1)*ScreenWidth,y:0,width:(scrollContainer?.bounds.width)!,height:(scrollContainer?.bounds.height)!)
        let tableView3Frame: CGRect = CGRect(x: CGFloat(2)*ScreenWidth,y:0,width:(scrollContainer?.bounds.width)!,height:(scrollContainer?.bounds.height)!)
        
        
        
        
        
        tableView1 = UITableView(frame: tableView1Frame, style: UITableViewStyle.grouped)
        
        tableView3 = UITableView(frame: tableView2Frame, style: UITableViewStyle.grouped)
        
         RCListVC.view.frame = tableView3Frame
        
        
        //创建一个重用的单元格
        tableView1!.register(UITableViewCell.self,
                                      forCellReuseIdentifier: "SwiftCell")
        tableView3!.register(UITableViewCell.self,
                             forCellReuseIdentifier: "SwiftCell")
        //创建表头标签
        let headerLabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: (scrollContainer?.bounds.width)!, height: 30))
        headerLabel1.backgroundColor = UIColor.flatPink
        headerLabel1.textColor = UIColor.white
        headerLabel1.numberOfLines = 0
        headerLabel1.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel1.text = "任务列表"
        headerLabel1.font = UIFont.italicSystemFont(ofSize: 20)
//        tableView1.tableHeaderView = headerLabel1
        
        let headerLabel3 = UILabel(frame: CGRect(x: 0, y: 0, width: (scrollContainer?.bounds.width)!, height: 30))
        headerLabel3.backgroundColor = UIColor.flatLime
        headerLabel3.textColor = UIColor.white
        headerLabel3.numberOfLines = 0
        headerLabel3.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel3.text = "日程清单"
        headerLabel3.font = UIFont.italicSystemFont(ofSize: 20)
//        tableView3.tableHeaderView = headerLabel3
        
        

        //添加子控制器
        
        tableView1.backgroundColor = UIColor.flatGray

        tableView3.backgroundColor = UIColor.flatGray
        
        tableView1.tag = 101

        RCListVC.view.tag = 102
        
        
        tableView3.tag = 103
        
        tableView1.delegate = self
        
        tableView3.delegate = self
        
        tableView1.dataSource = self

        tableView3.dataSource = self
        
        
        tableView1.isUserInteractionEnabled = true
        RCListVC.view.isUserInteractionEnabled = true

        tableView3.isUserInteractionEnabled = true
        
        tableView1.separatorStyle = UITableViewCellSeparatorStyle.singleLine

        tableView3.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        //加上约束
        tableView1.autoresizingMask = UIViewAutoresizing.flexibleHeight
        tableView3.autoresizingMask = UIViewAutoresizing.flexibleHeight
        RCListVC.view.autoresizingMask = UIViewAutoresizing.flexibleHeight
        

        
        scrollContainer?.addSubview(tableView1)
       
        scrollContainer?.addSubview(tableView3)
        scrollContainer?.addSubview(RCListVC.view)
        

        //配置scrollview容器
        scrollContainer?.contentSize = CGSize(width:3*ScreenWidth,height:0)
        scrollContainer?.showsHorizontalScrollIndicator = true
        scrollContainer?.delegate = self
        scrollContainer?.isPagingEnabled = true
        
        
        self.view.addSubview(scrollContainer!)
        
        
        
    }
    //    MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
//        加载测试模拟数据
        initDataForTest()
//        self.navItem.rightBarButtonItem = UIBarButtonItem(title: "菜单", style: .plain, target: self, action: #selector(popDownMenu))
        
        //加载日历 limeng
        view.addSubview(AddCalendar())
        
        //设置日历
        self.calendar.select(Date())
        self.view.addGestureRecognizer(self.scopeGesture)
        
        self.calendar.scope = .week
        self.calendar.accessibilityIdentifier = "calendar"
        //加载pason标签
        Person = MessageTopCell.newInstance()!  as MessageTopCell
        let headerFrame: CGRect = CGRect(x: 0 , y: NavigationH + FSCalendarStandardWeeklyPageHeight, width: ScreenWidth, height: HomeViewPasonLableHeight)
        Person.frame = headerFrame
        
        //设置segment
        configSegment()
        Person.backgroundColor = UIColor.flatSand
        Person.addSubview(segmentView!)
        view.addSubview(Person)
        //配置scrollview
        configScrollView()
        // 下拉刷新
        setupPullToRefresh()
        SetUI()
        
    }
    
    deinit {
        tableView1.removeAllPullToRefresh()
        tableView3.removeAllPullToRefresh()
    }
    
    func AddCalendar() -> FSCalendar{
        
        let calendar_temp = FSCalendar(frame: CGRect(x: 0, y: NavigationH, width: ScreenWidth, height: FSCalendarStandardMonthlyPageHeight))
        
        calendar_temp.dataSource = self
        calendar_temp.delegate = self
        self.calendar = calendar_temp
        return calendar_temp
        
    }
    
    
    func SetUI(){
        //      关闭掉自带的自动布局后，自己动态生成时一定要设置左右边距，不然宽度会变成0，这样就看不见了。
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        scrollContainer?.translatesAutoresizingMaskIntoConstraints = false
        
        Person.translatesAutoresizingMaskIntoConstraints = false
        
        //        日历
        calendar.addConstraint(NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1.0, constant: 300)
        )
        view.addConstraint(NSLayoutConstraint(item: calendar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 64))
        
        view.addConstraint(NSLayoutConstraint(item: calendar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: calendar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        
        //   登录者UI
        
        Person.addConstraint(NSLayoutConstraint(item: Person, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1.0, constant: HomeViewPasonLableHeight)
        )
        
        
        view.addConstraint(NSLayoutConstraint(item: Person, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: Person, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: Person, attribute: .top, relatedBy: .equal, toItem: calendar, attribute: .bottom, multiplier: 1, constant: 0))
        
        
        // scrollContainer界面
        scrollContainer.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1.0, constant: 500)
        )
        
        view.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .top , relatedBy: .equal, toItem: Person, attribute: .bottom, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .trailing , relatedBy: .equal, toItem: calendar, attribute: .trailing, multiplier: 1, constant: 0))
        
        
        
        view.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .bottom , relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 48))
        
        view.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .leading , relatedBy: .equal, toItem: calendar, attribute: .leading, multiplier: 1, constant: 0))
        
        
        
    }
    

    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        
        
        let shouldBegin = self.scrollContainer.contentOffset.y <= -self.scrollContainer.contentInset.top
//        手势向下传递
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
                
            }
            
            
        }
        return shouldBegin
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        //      如果不把日历的约束设置正确，这里是不会成功更新掉framde的。limeng
        self.calendar.constraints[0].constant = bounds.height
        //        self.calendar.frame.size.height = bounds.height
        
        self.view.layoutIfNeeded()
        
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
//    func popDownMenu(){
//        
//        let v = UIView.qzoneCurtain() as! SnailCurtainView
//        v.delegate = self
//        
//        popups = SnailQuickMaskPopups(maskStyle: MaskStyle.blackTranslucent, aView: v)
//        
//        popups.presentationStyle = PresentationStyle.top
//        
//        popups.delegate = self
//        popups.present(animated: true, completion: nil)
//        
//    }
    
    
}
//下拉刷新的封装调用
extension MessageViewController {
    
    func setupPullToRefresh() {
        tableView1.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount = 12
                self?.tableView1.endRefreshing(at: .top)
            }
        }
        
        tableView1.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount += 12
                self?.tableView1.reloadData()
                self?.tableView1.endRefreshing(at: .bottom)
            }
        }
        

        
        
        tableView3.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount = 12
                self?.tableView3.endRefreshing(at: .top)
            }
        }
        
        tableView3.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount += 12
                self?.tableView3.reloadData()
                self?.tableView3.endRefreshing(at: .bottom)
            }
        }
        
    }
}

extension MessageViewController: UITableViewDataSource ,UITableViewDelegate{
    
    
    //    有多少分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //    显示的数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.tag {
        case 101:
            let data = self.allnames![section]
            return data!.count
            
            
        case 103:
            let data = self.allnames3![section]
            return data!.count
            
        default:
            let data = self.allnames![section]
            return data!.count
            
        }
        

    }
    //绘制cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identify:String = "SwiftCell"
        let secno = indexPath.section
        
        switch tableView.tag {
        case 101:
            var data = self.allnames?[secno]
            if (secno == 0) {
                //同一形式的单元格重复使用，在声明时已注册
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: identify, for: indexPath) as UITableViewCell
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                let image = UIImage(named: "tabbar_home")
                cell.imageView?.image = image
                cell.textLabel?.text = data![indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell
            } else {
                //第二个分组表格使用详细标签
                let adCell = UITableViewCell(style: .subtitle, reuseIdentifier: "SwiftCell")
                adCell.textLabel?.text = data![indexPath.row]
                adCell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                adCell.detailTextLabel?.text = "这是\(data![indexPath.row])的说明"
                return adCell
            }

        case 103:
            var data = self.allnames3?[secno]
            if (secno == 0) {
                //同一形式的单元格重复使用，在声明时已注册
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: identify, for: indexPath) as UITableViewCell
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                let image = UIImage(named: "tabbar_home")
                cell.imageView?.image = image
                cell.textLabel?.text = data![indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell
            } else {
                //第二个分组表格使用详细标签
                let adCell = UITableViewCell(style: .subtitle, reuseIdentifier: "SwiftCell")
                adCell.textLabel?.text = data![indexPath.row]
                adCell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                adCell.detailTextLabel?.text = "这是\(data![indexPath.row])的说明"
                return adCell
            }

            
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: identify, for: indexPath) as UITableViewCell
            
            return cell
        }
        //为了提供表格显示性能，已创建完成的单元需重复使用
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
//    注意：    这里不能设为0，不然foot就消失了，会留下10个点的空白出来，让两个sesion之间产生距离，设成0.1，foot就成了一条线
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.flatGray
//        let titleLabel = UILabel()
//        if tableView.tag  == 101 {
//            titleLabel.text = self.adHeaders?[section]
//        }
//        else
//        {
//            
//            titleLabel.text = self.adHeaders3?[section]
//        }
//        titleLabel.textColor = UIColor.white
//        titleLabel.sizeToFit()
//        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 20)
//        headerView.addSubview(titleLabel)
//        return headerView
        var view:UIView = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor(red: 0xf0/255.0, green: 0xf0/255.0 , blue: 0xf6/255.0 , alpha: 1.0)
        
        var label:UILabel = UILabel(frame: CGRect(x: 20, y: 20, width: 100, height: 20))
        label.textColor = UIColor(red: 0x8f/255.0, green: 0x8f/255.0, blue: 0x94/255.0, alpha: 1.0)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(label)
        
        
        
        if tableView.tag  == 101 {
                        label.text = self.adHeaders?[section]
                    }
                    else
                    {
            
                        label.text = self.adHeaders3?[section]
                    }
        
            
        
        return view;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch tableView.tag {
        case 101:
            
            var headers =  self.adHeaders!
            return headers[section]
           
        case 103:
            
        
            var headers3 =  self.adHeaders3!
            return headers3[section]
        default:
             var headers =  self.adHeaders!
            return headers[section]

            
        }
        
    
    }
//    
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        
//        switch tableView.tag {
//        case 101:
//            
//            let data = self.allnames?[section]
//            return "第一页共\(data!.count)个分区"
//            
//        case 103:
//            
//            
//            let data = self.allnames?[section]
//            return "第三页共\(data!.count)个分区"
//        default:
//            let data = self.allnames?[section]
//            return "有\(data!.count)个"
//            
//        }
//
//        
//        
//}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       print("ssss")
    }
}


//scrollview的委托
extension MessageViewController:UIScrollViewDelegate{
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        if (historyY+20<targetContentOffset.pointee.y)
        {
//            self.tabBarController?.tabBar.isHidden = true

        }
        else if(historyY-20>targetContentOffset.pointee.y)
        {
//            self.tabBarController?.tabBar.isHidden = false

          }
        historyY=targetContentOffset.pointee.y
    }
    
    
    //scollview滑动代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
       
        let point = scrollView.contentOffset
        if point.y ==  0  && point.x != 0 {
            
        segmentView?.segmentWillMove(point: point)
        }
        
    }
    
    //scollview开始减速代理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    
    //scollview停止减速代理
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        var point = scrollView.contentOffset
        if point.y ==  0{
            segmentView?.segmentDidEndMove(point: point)
        }

        
    }
    
    
}


