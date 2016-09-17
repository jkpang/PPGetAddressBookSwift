//
//  AddressBookVC2.swift
//  PPGetAddressBookSwift
//
//  Created by AndyPang on 16/9/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

import UIKit

class AddressBookVC1: UIViewController {
    
    var tableView: UITableView!
    /// 所有联系人信息的字典
    var addressBookSouce = [String:[PPPersonModel]]()
    /// 所有分组的key值
    var keysArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "A~Z联系人分组排序"
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: UITableViewStyle.Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60.0
        view.addSubview(tableView)
        
        
        // MARK: - 获取A~Z分组顺序的通讯录
        PPGetAddressBook.getOrderAddressBook(addressBookInfo: { (addressBookDict, nameKeys) in
            
            self.addressBookSouce = addressBookDict  // 所有联系人信息的字典
            self.keysArray = nameKeys       // 所有分组的key值
            
            // 刷新tableView
            self.tableView.reloadData()
            
            }, authorizationFailure: {
                
                let alertView = UIAlertController.init(title: "提示", message: "请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBookSwift访问您的通讯录", preferredStyle: UIAlertControllerStyle.Alert)
                let confirm = UIAlertAction.init(title: "知道啦", style: UIAlertActionStyle.Cancel, handler:nil)
                alertView.addAction(confirm)
        })
        
    }
    
    deinit{
        print("挂了")
    }
    
}

extension AddressBookVC1: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return keysArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = keysArray[section]
        
        let array = addressBookSouce[key]
        
        return (array?.count)!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return keysArray[section]
    }
    
    // 右侧索引
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return keysArray
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        let modelArray = addressBookSouce[keysArray[indexPath.section]]
        let model = modelArray![indexPath.row]
        
        
        cell?.textLabel?.text = model.name
        cell?.imageView?.image = model.headerImage ?? UIImage.init(named: "defult")
        cell?.imageView?.layer.cornerRadius = 30
        cell?.imageView?.clipsToBounds = true
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let modelArray = addressBookSouce[keysArray[indexPath.section]]
        let model = modelArray![indexPath.row]
        
        let alertViewVC = UIAlertController.init(title: model.name, message:"\(model.mobileArray)", preferredStyle: UIAlertControllerStyle.Alert)
        let confirm = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Cancel, handler:nil)
        alertViewVC.addAction(confirm)
        self.presentViewController(alertViewVC, animated: true, completion: nil)
        
    }
    
}