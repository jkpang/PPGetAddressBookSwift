//
//  PPAddressBookHandle.swift
//  PPGetAddressBookSwift
//
//  Created by AndyPang on 16/9/16.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

import UIKit
import AddressBook
import Contacts

/// 一个联系人信息模型的闭包
typealias PPPersonModelClosure = (model: PPPersonModel)->()
/// 授权失败的闭包
typealias AuthorizationFailure = ()->()


class PPAddressBookHandle: NSObject {

    class func getAddressBookDataSource(personModel success: PPPersonModelClosure, authorizationFailure failure: AuthorizationFailure) {
        
        if #available(iOS 9.0, *) {
            // iOS9 之后
            getDataSourceFrom_IOS9_Later(personModel: success, authorizationFailure: failure)
        } else {
            // iOS9 之前
            getDataSourceFrom_IOS9_Ago(personModel: success, authorizationFailure: failure)
        }
        
    }
    
    
    // MARK: - IOS9之前获取通讯录的函数
    @available(iOS, introduced=8.0, deprecated=9.0)
    private class func getDataSourceFrom_IOS9_Ago(personModel success: PPPersonModelClosure, authorizationFailure failure: AuthorizationFailure) {
        
        // 1.获取授状态
        let status = ABAddressBookGetAuthorizationStatus()
        
        // 2.如果没有授权,先执行授权失败的闭包后return
        if status != ABAuthorizationStatus.Authorized {
            failure()
            return
        }
        
        // 3.创建通信录对象
        let addressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        // 4.按照按姓名属性的排序规则从通信录对象中请求所有的联系人
        let recordRef = ABAddressBookCopyDefaultSource(addressBook).takeRetainedValue()
        let allPeopleArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, recordRef,ABPersonGetSortOrdering()).takeRetainedValue() as Array
        
        // 5.遍历所有联系人
        for personInfo in allPeopleArray {
            
            let model = PPPersonModel()
            
            // 5.1 获取到联系人
            let person = personInfo as ABRecordRef
            
            // 5.2 获取联系人全名
            let name = ABRecordCopyCompositeName(person)?.takeRetainedValue() as String? ?? ""
            model.name = name
            
            // 5.3 获取头像数据
            let imageData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)?.takeRetainedValue() as NSData? ?? NSData.init()
            model.headerImage = UIImage.init(data: imageData)
            
            // 5.4 遍历每个人的电话号码
            let phones = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue();
            let phoneCount = ABMultiValueGetCount(phones)
            for i in 0..<phoneCount {
                // 获取号码
                let phoneValue = ABMultiValueCopyValueAtIndex(phones, i)?.takeRetainedValue() as! String? ?? ""
                let mobile = removeSpecialSubString(phoneValue)
                model.mobileArray.append(mobile)
                
            }
            
            success(model: model)
            
        }
        
    }
    
    // MARK: - IOS9之后获取通讯录的函数
    @available(iOS 9.0, *)
    private class func getDataSourceFrom_IOS9_Later(personModel success: PPPersonModelClosure, authorizationFailure failure: AuthorizationFailure) {
        
        // 1.获取授权状态
        let status = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        // 2.如果没有授权,先执行授权失败的闭包后return
        if status != CNAuthorizationStatus.Authorized {
            failure()
            return
        }
        
        // 3.获取联系人
        // 3.1.创建联系人仓库
        let store = CNContactStore.init();
        
        // 3.2.创建联系人的请求对象
        // keys决定能获取联系人哪些信息,例:姓名,电话,头像等
        let fetchKeys = [CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName),CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey]
        let fetchRequest = CNContactFetchRequest.init(keysToFetch: fetchKeys);
        

        // 3.请求获取联系人
        var contacts = [CNContact]()
        do {
            try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (let contact, let stop) -> Void in
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
            model.name = CNContactFormatter.stringFromContact(contact, style: CNContactFormatterStyle.FullName) ?? ""
            
            // 获取头像
            let imageData = contact.thumbnailImageData ?? NSData.init()
            model.headerImage = UIImage.init(data: imageData)
            
            // 遍历一个人的所有电话号码
            for labelValue in contact.phoneNumbers {
                let phoneNumber = labelValue.value as! CNPhoneNumber
                model.mobileArray.append(phoneNumber.stringValue)
            }
            
            // 将联系人模型回调出去
            success(model: model)
        }
        
    }
    
    
    /**
     过滤指定字符串(可自定义添加自己过滤的字符串)
     */
    class func removeSpecialSubString(string: String) -> String {

        let resultString = string.stringByReplacingOccurrencesOfString("+86", withString: "")
            .stringByReplacingOccurrencesOfString("-", withString: "")
            .stringByReplacingOccurrencesOfString("(", withString: "")
            .stringByReplacingOccurrencesOfString(")", withString: "")
            .stringByReplacingOccurrencesOfString(" ", withString: "")
            .stringByReplacingOccurrencesOfString(" ", withString: "")
        
        return resultString;
    }
    
}
