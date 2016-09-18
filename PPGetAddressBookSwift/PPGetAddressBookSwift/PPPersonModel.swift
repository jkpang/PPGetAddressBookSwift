//
//  PPPersonModel.swift
//  PPGetAddressBookSwift
//
//  Created by AndyPang on 16/9/16.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

/*
 *********************************************************************************
 *
 * 如果您在使用 PPNumberButtonSwift 的过程中出现bug或有更好的建议,还请及时以下列方式联系我,我会及
 * 时修复bug,解决问题.
 *
 * Weibo : CoderPang
 * Email : jkpang@outlook.com
 * QQ    : 2406552315
 * GitHub: https://github.com/jkpang
 *
 * PS:PPGetAddressBookSwift的Objective-C版本:
 * https://github.com/jkpang/PPGetAddressBook
 *
 *********************************************************************************
 */


import UIKit

public class PPPersonModel: NSObject {
    
    /// 联系人姓名
    public var name: String = ""
    
    /// 联系人电话数组,一个联系人可能存储多个号码
    public var mobileArray: [String] = []
    
    /// 联系人头像
    public var headerImage: UIImage?
    
}
