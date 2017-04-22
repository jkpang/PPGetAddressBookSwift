//
//  PPAddressBookHandle.swift
//  PPGetAddressBookSwift
//
//  Created by AndyPang on 16/9/16.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

/*
 *********************************************************************************
 *
 *⭐️⭐️⭐️ 新建 PP-iOS学习交流群: 323408051 欢迎加入!!! ⭐️⭐️⭐️
 *
 * 如果您在使用 PPGetAddressBookSwift 的过程中出现bug或有更好的建议,还请及时以下列方式联系我,我会及
 * 时修复bug,解决问题.
 *
 * Weibo : jkpang-庞
 * Email : jkpang@outlook.com
 * QQ 群 : 323408051
 * GitHub: https://github.com/jkpang
 *
 * PS:PPGetAddressBookSwift的Objective-C版本:
 * https://github.com/jkpang/PPGetAddressBook
 *
 * 如果 PPGetAddressBookSwift 好用,希望您能Star支持,你的 ⭐️ 是我持续更新的动力!
 *********************************************************************************
 */

import UIKit
import AddressBook
import Contacts

/// 一个联系人信息模型的闭包
public typealias PPPersonModelClosure = (_ model: PPPersonModel)->()
/// 授权失败的闭包
public typealias AuthorizationFailure = ()->()


class PPAddressBookHandle {
    
    func requestAuthorizationWithSuccessClosure(success: @escaping ()->()) {
        
        if #available(iOS 9.0, *) {
            
            if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == CNAuthorizationStatus.authorized {
                return
            }
            contactStore.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                
                if granted {
                    success() ; print("授权成功")
                } else {
                    print("授权失败")
                }
            })
            
            
        } else {
            
            // 1.获取授权的状态
            let status = ABAddressBookGetAuthorizationStatus()
            // 2.判断授权状态,如果是未决定状态,才需要请求
            if status == ABAuthorizationStatus.notDetermined {
                // 3.创建通讯录进行授权
                ABAddressBookRequestAccessWithCompletion(addressBook, { (granted, error) in
                    if granted {
                        success() ; print("授权成功")
                    }else {
                        print("授权失败")
                    }
                })
                
            }
            
        }
        
    }
    
    func getAddressBookDataSource(personModel success: PPPersonModelClosure, authorizationFailure failure: AuthorizationFailure) {
        
        if #available(iOS 9.0, *) {
            // iOS9 之后
            getDataSourceFrom_IOS9_Later(personModel: success, authorizationFailure: failure)
        } else {
            // iOS9 之前
            getDataSourceFrom_IOS9_Ago(personModel: success, authorizationFailure: failure)
        }
    
    }
    
    
    // MARK: - IOS9之前获取通讯录的函数
    @available(iOS, introduced: 8.0, deprecated: 9.0)
    private func getDataSourceFrom_IOS9_Ago(personModel success: PPPersonModelClosure, authorizationFailure failure: AuthorizationFailure) {
        
        // 1.获取授状态
        let status = ABAddressBookGetAuthorizationStatus()
        
        // 2.如果没有授权,先执行授权失败的闭包后return
        if status != ABAuthorizationStatus.authorized {
            failure()
            return
        }
        
        // 3.创建通信录对象
        //let addressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        // 4.按照按姓名属性的排序规则从通信录对象中请求所有的联系人
        let recordRef = ABAddressBookCopyDefaultSource(addressBook).takeRetainedValue()
        let allPeopleArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, recordRef,ABPersonGetSortOrdering()).takeRetainedValue() as Array
        
        // 5.遍历所有联系人
        for personInfo in allPeopleArray {
            
            let model = PPPersonModel()
            
            // 5.1 获取到联系人
            let person = personInfo as ABRecord
            
            // 5.2 获取联系人全名
            let name = ABRecordCopyCompositeName(person)?.takeRetainedValue() as String? ?? "无名氏"
            model.name = name
            
            // 5.3 获取头像数据
            let imageData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)?.takeRetainedValue() as NSData? ?? NSData.init()
            model.headerImage = UIImage.init(data: imageData as Data)
            
            // 5.4 遍历每个人的电话号码
            let phones = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue();
            let phoneCount = ABMultiValueGetCount(phones)
            for i in 0..<phoneCount {
                // 获取号码
                let phoneValue = ABMultiValueCopyValueAtIndex(phones, i)?.takeRetainedValue() as! String? ?? ""
                let mobile = removeSpecialSubString(string: phoneValue)
                model.mobileArray.append(mobile)
                
            }
            
            success(model)
            
        }
        
    }
    
    // MARK: - IOS9之后获取通讯录的函数
    @available(iOS 9.0, *)
    private func getDataSourceFrom_IOS9_Later(personModel success: PPPersonModelClosure, authorizationFailure failure: AuthorizationFailure) {
        
        // 1.获取授权状态
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        // 2.如果没有授权,先执行授权失败的闭包后return
        if status != CNAuthorizationStatus.authorized {
            failure()
            return
        }
        
        // 3.获取联系人
        // 3.1.创建联系人仓库
        //let store = CNContactStore.init();
        
        // 3.2.创建联系人的请求对象
        // keys决定能获取联系人哪些信息,例:姓名,电话,头像等
        let fetchKeys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName),CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey] as [Any]
        let fetchRequest = CNContactFetchRequest.init(keysToFetch: fetchKeys as! [CNKeyDescriptor]);
        
        
        // 3.请求获取联系人
        var contacts = [CNContact]()
        do {
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, stop) -> Void in
                contacts.append(contact)
            })
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        // 3.1遍历联系人
        for contact in contacts {
            
            // 创建联系人模型
            let model = PPPersonModel()
            
            // 获取联系人全名
            model.name = CNContactFormatter.string(from: contact, style: CNContactFormatterStyle.fullName) ?? "无名氏"
            
            // 获取头像
            let imageData = contact.thumbnailImageData ?? NSData.init() as Data
            model.headerImage = UIImage.init(data: imageData)
            
            // 遍历一个人的所有电话号码
            for labelValue in contact.phoneNumbers {
                let phoneNumber = labelValue.value 
                model.mobileArray.append(phoneNumber.stringValue)
            }
            
            // 将联系人模型回调出去
            success(model)
        }
        
    }
    
    
    /**
     过滤指定字符串(可自定义添加自己过滤的字符串)
     */
    func removeSpecialSubString(string: String) -> String {
        
        let resultString = string.replacingOccurrences(of: "+86", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        return resultString;
    }
    
    
    // MARK: - lazy
    @available(iOS 9.0, *)
    lazy var contactStore: CNContactStore = {
        let contactStore = CNContactStore.init()
        return contactStore
    }()
    
    @available(iOS, introduced: 8.0, deprecated: 9.0)
    lazy var addressBook: ABAddressBook = {
        let addressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        return addressBook
    }()
    
}
