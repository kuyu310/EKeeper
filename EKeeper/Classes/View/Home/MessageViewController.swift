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
    
    
    
    
    
    var tableView :UITableView!
    var Person : MessageTopCell!
    fileprivate weak var calendar: FSCalendar!
    var scrollContainer: UIScrollView!
    
    var tableView1: UITableView!
    var tableView2: UITableView!
    var tableView3: UITableView!
    
    var segmentedTab : TTSegmentedControl!
    var segmentIndex: Int = 0
    
    
    fileprivate var dataSourceCount = 11
    //MARK:模拟数据
    var baby = ["宝宝0","宝宝1","宝宝2","宝宝3","宝宝4","宝宝5","宝宝6","宝宝7","宝宝8","宝宝9","宝宝10","宝宝11"]
    
    var babyImage = ["宝宝0.jpg","宝宝1.jpg","宝宝2.jpg","宝宝3.jpg","宝宝4.jpg","宝宝5.jpg","宝宝6.jpg","宝宝7.jpg","宝宝8.jpg","宝宝9.jpg","宝宝10.jpg","宝宝11.jpg"]
    
    
    
    var popups = SnailQuickMaskPopups()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    
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
    func configSegment() -> TTSegmentedControl{
        
        let segmentedC1 = TTSegmentedControl()
        segmentedC1.frame = CGRect(x: 0, y: 64, width: ScreenWidth, height: 38)
        segmentedC1.itemTitles = ["任务","消息","@我"]
        segmentedC1.allowChangeThumbWidth = false
        segmentedC1.selectedTextFont = UIFont.systemFont(ofSize: 12, weight: 0.3)
        segmentedC1.defaultTextFont = UIFont.systemFont(ofSize: 12, weight: 0.01)
        segmentedC1.cornerRadius = 0
        segmentedC1.useGradient = true
        segmentedC1.useShadow = false
        
        segmentedC1.thumbGradientColors = [ UIColor.flatYellow , UIColor.flatYellow]
        segmentedC1.containerBackgroundColor = UIColor.flatSandDark
        
        segmentedC1.didSelectItemWith = { (index, title) -> () in
            
            self.segmentIndex = index
            
            let point = CGPoint(x:CGFloat(index)*ScreenWidth,y:0)
            self.scrollContainer?.setContentOffset(point, animated: true)
            
        }
        return segmentedC1
    }
    //MARK:配置scroll视图容器
    func configScrollView()  {
        //scrollview容器
        let scrollViewframe: CGRect = CGRect(x: 0 , y: NavigationH + FSCalendarStandardWeeklyPageHeight, width: ScreenWidth, height: 500)
        
        scrollContainer = UIScrollView.init(frame: scrollViewframe)
        
        
        
        let tableView1Frame: CGRect = CGRect(x: CGFloat(0)*ScreenWidth,y:0,width:(scrollContainer?.bounds.width)!,height:(scrollContainer?.bounds.height)!)
        let tableView2Frame: CGRect = CGRect(x: CGFloat(1)*ScreenWidth,y:0,width:(scrollContainer?.bounds.width)!,height:(scrollContainer?.bounds.height)!)
        let tableView3Frame: CGRect = CGRect(x: CGFloat(2)*ScreenWidth,y:0,width:(scrollContainer?.bounds.width)!,height:(scrollContainer?.bounds.height)!)
        
        
        
        tableView1 = UITableView(frame: tableView1Frame, style: UITableViewStyle.plain)
        tableView2 = UITableView(frame: tableView2Frame, style: UITableViewStyle.plain)
        tableView3 = UITableView(frame: tableView3Frame, style: UITableViewStyle.plain)
        
        //添加子控制器
        
        tableView1.backgroundColor = UIColor.flatSand
        tableView2.backgroundColor = UIColor.flatGray
        tableView3.backgroundColor = UIColor.flatGreen
        
        tableView1.tag = 101
        tableView2.tag = 102
        tableView3.tag = 103
        
        tableView1.delegate = self
        tableView2.delegate = self
        tableView3.delegate = self
        
        tableView1.dataSource = self
        tableView2.dataSource = self
        tableView3.dataSource = self
        
        tableView1.isUserInteractionEnabled = true
        tableView2.isUserInteractionEnabled = true
        tableView3.isUserInteractionEnabled = true
        
        tableView1.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView2.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView3.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        
        
        scrollContainer?.addSubview(tableView1)
        
        scrollContainer?.addSubview(tableView2)
        
        scrollContainer?.addSubview(tableView3)
        
        
        
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
        
        self.navItem.rightBarButtonItem = UIBarButtonItem(title: "菜单", style: .plain, target: self, action: #selector(popDownMenu))
        
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
        segmentedTab = configSegment()
        Person.backgroundColor = UIColor.flatSand
        Person.addSubview(segmentedTab)
        view.addSubview(Person)
        //配置scrollview
        configScrollView()
        // 下拉刷新
        setupPullToRefresh()
        SetUI()
        
    }
    
    deinit {
        tableView1.removeAllPullToRefresh()
        tableView2.removeAllPullToRefresh()
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
        
        
        //        table界面
        scrollContainer.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1.0, constant: 500)
        )
        
        view.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .top , relatedBy: .equal, toItem: Person, attribute: .bottom, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .trailing , relatedBy: .equal, toItem: calendar, attribute: .trailing, multiplier: 1, constant: 0))
        
        
        
        view.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .bottom , relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: scrollContainer, attribute: .leading , relatedBy: .equal, toItem: calendar, attribute: .leading, multiplier: 1, constant: 0))
        
        
        
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //        let shouldBegin = self.scrollContainer.contentOffset.y <= -self.scrollContainer.contentInset.top
        
        let shouldBegin = self.scrollContainer.contentOffset.y <= -self.scrollContainer.contentInset.top
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
    
    func popDownMenu(){
        
        let v = UIView.qzoneCurtain() as! SnailCurtainView
        v.delegate = self
        
        popups = SnailQuickMaskPopups(maskStyle: MaskStyle.blackTranslucent, aView: v)
        
        popups.presentationStyle = PresentationStyle.top
        
        popups.delegate = self
        popups.present(animated: true, completion: nil)
        
    }
    
    
}
//下拉刷新的封装调用
extension MessageViewController {
    
    func setupPullToRefresh() {
        tableView1.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount = 20
                self?.tableView1.endRefreshing(at: .top)
            }
        }
        
        tableView1.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount += 20
                self?.tableView1.reloadData()
                self?.tableView1.endRefreshing(at: .bottom)
            }
        }
        
        
        tableView2.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount = 20
                self?.tableView2.endRefreshing(at: .top)
            }
        }
        
        tableView2.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount += 20
                self?.tableView2.reloadData()
                self?.tableView2.endRefreshing(at: .bottom)
            }
        }
        
        
        
        
        tableView3.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount = 20
                self?.tableView3.endRefreshing(at: .top)
            }
        }
        
        tableView3.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.dataSourceCount += 20
                self?.tableView3.reloadData()
                self?.tableView3.endRefreshing(at: .bottom)
            }
        }
        
    }
}

extension MessageViewController: UITableViewDataSource ,UITableViewDelegate{
    
    
    //    有多少分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //    显示的数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceCount
    }
    //绘制cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let initIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: initIdentifier)
        //下面两个属性对应subtitle
        cell.textLabel?.text = baby[indexPath.row]
        cell.detailTextLabel?.text = "baby\(indexPath.row)"
        
        //添加照片
        cell.imageView?.image = UIImage(named: babyImage[indexPath.row])
        cell.imageView!.layer.cornerRadius = 40
        cell.imageView!.layer.masksToBounds = true
        //        修改样式
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor.flatSand
        
        
        return cell
    }
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("dddd")
    }
    
}
//scrollview的委托
extension MessageViewController:UIScrollViewDelegate{
    
    
    //scollview滑动代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let point = scrollView.contentOffset
        //let num = point.x/ScreenWidth
        
        //segmentedTab.selectItemAt(index: Int(num), animated: true)
        
        
    }
    
    //scollview开始减速代理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    
    //scollview停止减速代理
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        //        let point = CGPoint(x:CGFloat(index)*ScreenWidth,y:0)
        //        self.scrollContainer?.setContentOffset(point, animated: true)
        //
        //
        let point = scrollView.contentOffset
        
        let num = point.x/ScreenWidth
        if self.segmentIndex != Int(num) {
            
            segmentedTab.selectItemAt(index: Int(num), animated: true)
        }
        
    }
    
    
}


