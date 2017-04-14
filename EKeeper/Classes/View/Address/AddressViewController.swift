//
//  HomeViewCV.swift
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation




private let originalCellId = "AddressCell"

class AddressViewController: KeeperBaseViewController{
    
    var AddressDatas: [AddressData] = []
    
    var isSwipeRightEnabled = true
    
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    var addressTable: UITableView?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    let tableViewFrame: CGRect = CGRect(x: 0,y:NavigationH,width: ScreenWidth,height:ScreenHeight)
    
    
    var adHeaders = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.flatWhite
        
        
        adHeaders = [
            "新产品部",
            "市场策划支持部",
            "终端研发部",
            "密码机硬件部"
        ]
        
        
        addressTable = UITableView(frame: tableViewFrame, style: UITableViewStyle.grouped)
        
        addressTable?.allowsSelection = true
        addressTable?.allowsMultipleSelectionDuringEditing = true
        addressTable?.rowHeight = UITableViewAutomaticDimension
        addressTable?.estimatedRowHeight = 100
        addressTable?.register(UITableViewCell.self,
                               forCellReuseIdentifier: "AddressCellCompanny")
        
        addressTable?.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        addressTable?.dataSource = self
        addressTable?.delegate = self
        //        加上约束，让底部不被遮挡
        addressTable?.autoresizingMask = UIViewAutoresizing.flexibleHeight
        view.insertSubview(addressTable!, belowSubview: navigationBar)
        
        
        resetData()
        
        
        setupSearchController()
        
    }
    
    func setupSearchController(){
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        addressTable?.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["所有","常用","新加"]
        searchController.searchBar.delegate = self
        
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "所有") {
        addressTable?.reloadData()
    }
    func resetData() {
        AddressDatas = mockAddress
        AddressDatas.forEach { $0.unread = false }
        addressTable?.reloadData()
    }
    
    func createSelectedBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }
    
    
    
    
}

extension AddressViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension AddressViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("lniahao")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return adHeaders.count
            
        }
        else{
            return AddressDatas.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == 0 {
            
            let toTop = UITableViewRowAction(style: .normal, title: "置顶") { action, index in
                print("more button tapped")
            }
            toTop.backgroundColor = UIColor.flatRed
            
            
            return [toTop]

        }
        else{
            
            let toTop = UITableViewRowAction(style: .normal, title: "置顶") { action, index in
                
                var first:IndexPath = IndexPath(row: 0, section: 1)
                
                
                tableView.moveRow(at: indexPath, to: first)
                

            }
            toTop.backgroundColor = UIColor.flatRed
            let pTalk = UITableViewRowAction(style: .normal, title: "私聊") { action, index in
                print("favorite button tapped")
            }
            pTalk.backgroundColor = UIColor.flatOrange
            
            let telephone = UITableViewRowAction(style: .normal, title: "电话") { action, index in
                
                UIApplication.shared.openURL(URL(string: "telprompt://10086")!)
                
            }
            telephone.backgroundColor = UIColor.flatBlueDark
            
            
            return [telephone, pTalk, toTop]

        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identify:String = "AddressCellCompanny"
        
        let secno = indexPath.section
        
        if (secno == 0) {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: identify, for: indexPath) as UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            let image = UIImage(named: "tabbar_home")
            cell.imageView?.image = image
            cell.textLabel?.text = adHeaders[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            cell.selectedBackgroundView = createSelectedBackgroundView()
            
            let Address = AddressDatas[indexPath.row]
            cell.nameLabel.text = Address.name
            
            cell.telLable.text = Address.phoneNumber
            cell.leverLabel.text = Address.level
            cell.imageLabel.image = UIImage(named: Address.avatar)
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            cell.isUserInteractionEnabled=true

            return cell
        }
        
        
        
    }
    

    
}
class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}



enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}
