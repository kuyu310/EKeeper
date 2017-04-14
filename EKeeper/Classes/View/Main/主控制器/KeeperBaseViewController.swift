//  KeeperBaseViewController.swift
//  作为所有视图的基础类使用
//  李萌add

import UIKit

/// 所有主控制器的基类控制器
class KeeperBaseViewController: UIViewController {
    
    /// 访客视图信息字典
    var visitorInfoDictionary: [String: String]?
    
   
    /// 刷新控件
   
    /// 上拉刷新标记
    var isPullup = false
    
    /// 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 64))
    /// 自定义的导航条目 - 以后设置导航栏内容，统一使用 navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        

    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 重写 title 的 didSet
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    /// 加载数据 - 具体的实现由子类负责
    func loadData() {
        // 如果子类不实现任何方法，默认关闭刷新控件
        
    }
}

// MARK: - 访客视图监听方法
extension KeeperBaseViewController {
    
    /// 登录成功处理
     @objc func loginSuccess(n: Notification) {
        
        print("登录成功 \(n)")
        
        // 登录前左边是注册，右边是登录
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        // 更新 UI => 将访客视图替换为表格视图
        // 需要重新设置 view
        // 在访问 view 的 getter 时，如果 view == nil 会调用 loadView -> viewDidLoad
        view = nil
        
        // 注销通知 -> 重新执行 viewDidLoad 会再次注册！避免通知被重复注册
        NotificationCenter.default.removeObserver(self)
    }
    

}

// MARK: - 设置界面
extension KeeperBaseViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
      
        
    }
    
       
    /// 设置访客视图
    private func setupVisitorView() {
       
        
        
      }
    
    /// 设置导航条
    private func setupNavigationBar() {
        // 添加导航条
        view.addSubview(navigationBar)
        // 将 item 设置给 bar
        navigationBar.items = [navItem]
        // 1> 设置 navBar 整个背景的渲染颜色
        navigationBar.barTintColor = UIColor.flatSkyBlueDark
        // 2> 设置 navBar 的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        // 3> 设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
    }
}



