//
//  PPPersonModel.swift
//  PPGetAddressBookSwift
//
//  Created by AndyPang on 16/9/16.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

import UIKit

class PPPersonModel: NSObject {

    /// 联系人姓名
    var name: String = ""
    /// 联系人电话数组,一个联系人可能存储多个号码
    var mobileArray: [String] = []
    /// 联系人头像
    var headerImage: UIImage?
    
}
