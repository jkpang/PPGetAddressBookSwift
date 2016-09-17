//
//  AddressBookVC2.swift
//  PPGetAddressBookSwift
//
//  Created by AndyPang on 16/9/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

import UIKit

class AddressBookVC2: UIViewController {
    
    var tableView: UITableView!
    
    /// 联系人模型数组
    var dataSourceArray = [PPPersonModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "原始顺序"
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60.0
        view.addSubview(tableView)
        
        
        // MARK: - 获取原始顺序联系人的模型数组
        PPGetAddressBook.getOriginalAddressBook(addressBookArray: { (addressBookArray) in
            
            self.dataSourceArray = addressBookArray
            
            self.tableView.reloadData()
            
            }, authorizationFailure: {
                
                let alertViewVC = UIAlertController.init(title: "提示", message: "请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBookSwift访问您的通讯录", preferredStyle: UIAlertControllerStyle.Alert)
                let confirm = UIAlertAction.init(title: "知道啦", style: UIAlertActionStyle.Cancel, handler:nil)
                alertViewVC.addAction(confirm)
                self.presentViewController(alertViewVC, animated: true, completion: nil)
        })
        
    }
    
    deinit{
        print("挂了")
    }
}

extension AddressBookVC2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSourceArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
    
        let model = dataSourceArray[indexPath.row]
        
        cell?.textLabel?.text = model.name
        cell?.imageView?.image = model.headerImage ?? UIImage.init(named: "defult")
        cell?.imageView?.layer.cornerRadius = 30
        cell?.imageView?.clipsToBounds = true
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataSourceArray[indexPath.row]
        
        let alertViewVC = UIAlertController.init(title: model.name, message:"\(model.mobileArray)", preferredStyle: UIAlertControllerStyle.Alert)
        let confirm = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Cancel, handler:nil)
        alertViewVC.addAction(confirm)
        self.presentViewController(alertViewVC, animated: true, completion: nil)
    }
    
}