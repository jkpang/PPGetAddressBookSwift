//
//  ViewController.swift
//  PPGetAddressBookSwift
//
//  Created by AndyPang on 16/9/16.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    
    let dateSource = ["A~Z顺序排序","原始顺序"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "PPGetAddressBook Swift版"
        

        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dateSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = dateSource[indexPath.row]
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            // A~Z分组排序
            navigationController?.pushViewController(AddressBookVC1(), animated: true)
            
        } else if indexPath.row == 1{
            //原始顺序
            navigationController?.pushViewController(AddressBookVC2(), animated: true)
        }
    }

}

