//
//  HomeViewCV.swift
//  EKeeper
//
//  Created by limeng on 2017/3/30.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
import SwipeCellKit



private let originalCellId = "AddressCell"

class AddressViewController: KeeperBaseViewController{
    
    var AddressDatas: [AddressData] = []
    var defaultOptions = SwipeTableOptions()
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
        
        
        addressTable?.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        
       
        addressTable?.register(UITableViewCell.self,
                             forCellReuseIdentifier: "AddressCellCompanny")
        
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
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
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
extension AddressViewController: SwipeTableViewCellDelegate,UITableViewDelegate, UITableViewDataSource {


    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
            return nil
            
        } else {
            let flag = SwipeAction(style: .default, title: nil, handler: nil)
            flag.hidesWhenSelected = true
            configure(action: flag, with: .flag)
            
            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                self.AddressDatas.remove(at: indexPath.row)
            }
            configure(action: delete, with: .trash)
            
            let cell = tableView.cellForRow(at: indexPath) as! AddressCell
            let closure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
            let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                controller.addAction(UIAlertAction(title: "Reply", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Forward", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Mark...", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Notify Me...", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Move Message...", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: closure))
                self.present(controller, animated: true, completion: nil)
            }
            configure(action: more, with: .more)
            
            return [delete, flag, more]
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 11
        case .circular:
            options.buttonSpacing = 4
            options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        }
        
        return options
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return adHeaders.count
            
        }
        else{
            return AddressDatas.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
            cell.delegate = self
            cell.selectedBackgroundView = createSelectedBackgroundView()
            
            let Address = AddressDatas[indexPath.row]
            cell.nameLabel.text = Address.name
            
            cell.telLabel.text = Address.phoneNumber
            cell.leverLabel.text = Address.level
            cell.imageLabel.image = UIImage(named: Address.avatar)
            
           

             return cell
        }
        
        
       
    }

    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
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


enum ActionDescriptor {
    case read, unread, more, flag, trash
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .read: return "Read"
        case .unread: return "Unread"
        case .more: return "打电话"
        case .flag: return "私聊"
        case .trash: return "短信"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .read: name = "Read"
        case .unread: name = "Unread"
        case .more: name = "More"
        case .flag: name = "Flag"
        case .trash: name = "Trash"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .read, .unread: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .flag: return #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        case .trash: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    }
}


enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}
