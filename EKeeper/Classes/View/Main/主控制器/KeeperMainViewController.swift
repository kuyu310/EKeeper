//
//  KeeperMainViewController.swift
//  limeng

//

import UIKit
import SVProgressHUD

/// 主控制器
class KeeperMainViewController: ESTabBarController {

    
    var hotKeyInfo: [[String : String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //给tabbar加载由navigation包裹的自控制器viewcontrollers
        setupChildControllers()
        //设置tabbar的UI和回调函数
        setTabbarUI()
        
    }
    
    
}

//MARK: 设置tabbar的ui
extension KeeperMainViewController{
    
    fileprivate func setTabbarUI(){
        
        tabBar.shadowImage = UIImage(named: "transparent")
        tabBar.backgroundImage = UIImage(named: "background_dark")
        self.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        
        self.didHijackHandler = {
           [weak tabBarController] tabbarController, viewController, index in
           guard let hotKeyInfo_temp = self.hotKeyInfo
           else{
                return
            }
            
          
        }
        
    }
    
    
}
// extension 类似于 OC 中的 分类，在 Swift 中还可以用来切分代码块
// 可以把相近功能的函数，放在一个 extension 中
// 便于代码维护
// 注意：和 OC 的分类一样，extension 中不能定义属性
// MARK: - 设置界面
extension KeeperMainViewController {
    /// 设置所有子控制器
    fileprivate func setupChildControllers() {
        

         // 0. 获取沙盒 json 路径
        let docDir = ActionedPath
        let jsonPath  = docDir.appendingPathComponent("main.json")
        
        var data = NSData(contentsOfFile: jsonPath)
        
        // 判断 data 是否有内容，如果没有，说明本地沙盒没有文件
        if data == nil {
            // 从 Bundle 加载 data
            let path = Bundle.main.path(forResource: "main", ofType: "json")
            
            data = NSData(contentsOfFile: path!)
        }

        // 反序列化转换成数组, 这个数组里面的内容是字典类型，看清楚这里，是两个中括号！limeng
        
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]]
            else {
                return
           }
       
        
        // 遍历数组，循环创建控制器数组
//        定义一个controller数组
        var arrayOfControllers = [UIViewController]()
        for dict in array! {
            
            arrayOfControllers.append(makeController(dict: dict))
        }
        

        
        // 设置 tabBar 的子控制器
        viewControllers = arrayOfControllers
        
    }
    
    fileprivate func makeController(dict: [String: AnyObject]) -> UIViewController{
        
        // 1. 取得字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let imageNameSelected = dict["imageNameSelected"] as? String,
            
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? KeeperBaseViewController.Type,
            //保存访客视图的相关信息
            let visitorDict = dict["visitorInfo"] as? [String: String]
            else {
                return UIViewController()
            }
        // 2. 创建视图控制器
        let vc = cls.init()
        
        vc.title = title
        
        // 设置控制器的访客信息字典
        vc.visitorInfoDictionary = visitorDict
        
        // 3. 设置图像
        let nav = KeeperNavigationController.init(rootViewController:vc)
        //对中央按钮的判断
        if clsName == "HotKeyViewController" {
        //获取热键信息
            
        hotKeyInfo = dict["hotKeyInfo"] as? [[String: String]]
 
        //更新tabbar
        nav.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: imageName), selectedImage: UIImage(named: imageNameSelected as! String))
        }
        else{
            
             nav.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: imageNameSelected as! String))
            
        }
        return nav
        
    }
    
    
    func  login(){
        
        print("登录")
    }
    func  register(){
        
        print("注册")
    }

}
