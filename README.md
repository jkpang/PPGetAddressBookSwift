# PPGetAddressBookSwift
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-orange.svg) ![](https://img.shields.io/badge/pod-v0.2.0-blue.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)  [![](https://img.shields.io/badge/weibo-%40CoderPang-yellow.svg)](http://weibo.com/5743737098/profile?rightmod=1&wvr=6&mod=personinfo&is_all=1)

PPGetAddressBookSwift与Objective-C版本功能与特性相同(基于swift语言的特性,此版本会比OC版性能要好一些).在这里就不多做介绍.

####Objective-C版本,请戳: https://github.com/jkpang/PPGetAddressBook

###新建 PP-iOS学习交流群 : 323408051 有关于PP系列封装的问题和iOS技术可以在此群讨论

[简书地址](http://www.jianshu.com/p/b51a6125bcff) ;

![image](https://github.com/jkpang/PPGetAddressBook/blob/master/AddressBook.mov.gif)

##Requirements 要求
* iOS 8+
* Xcode 8+

##Installation 安装
###1.手动安装:
`下载DEMO后,将子文件夹PPGetAddressBookSwift拖入到项目中,无须import,直接使用`
###2.CocoaPods安装:
first
`pod 'PPGetAddressBookSwift',:git => 'https://github.com/jkpang/PPGetAddressBookSwift.git'`

then
`pod install或pod install --no-repo-update`

在你需要使用的地方 import PPGetAddressBook

如果发现pod search PPGetAddressBookSwift 不是最新版本，在终端执行pod setup命令更新本地spec镜像缓存(时间可能有点长),重新搜索就OK了
##Usage 使用方法
****注意, 在iOS 10系统下必须在info.plist文件中配置获取隐私数据权限声明 : [兼容iOS 10：配置获取隐私数据权限声明
](http://www.jianshu.com/p/616240463a7a)***
###一、首先必须要请求用户是否授权APP访问通讯录的权限(建议在APPDeletegate.m中的didFinishLaunchingWithOptions方法中调用)

```swift
    // MARK: - 请求用户获取通讯录权限, 必须调用
    PPGetAddressBook.requestAddressBookAuthorization()
```
###二、获取通讯录
###1.获取按联系人姓名首字拼音A~Z排序(已处理姓名所有字符的排序问题),一句话搞定!

```swift
// MARK: - 获取A~Z分组顺序的通讯录
PPGetAddressBook.getOrderAddressBook(addressBookInfo: { (addressBookDict, nameKeys) in
            
    self.addressBookSouce = addressBookDict  // 所有联系人信息的字典
    self.keysArray = nameKeys       // 所有分组的key值数组
    // 刷新tableView
    self.tableView.reloadData()
            
    }, authorizationFailure: {
       print("请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBookSwift访问您的通讯录")  
})


   
```
###2.获取原始顺序的联系人模型,未分组,一句话搞定!

```swift
// MARK: - 获取原始顺序联系人的模型数组
PPGetAddressBook.getOriginalAddressBook(addressBookArray: { (addressBookArray) in
            
self.dataSourceArray = addressBookArray    
self.tableView.reloadData()   

    }, authorizationFailure: {
    print("请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBookSwift访问您的通讯录") 
})

```

如果你有更好的实现方法,希望不吝赐教!
####你的star是我持续更新的动力!
===
##CocoaPods更新日志
* 2016.10.30(tag:0.2.0)--1.对姓"长","沈","厦","地","冲"多音字进行优化处理; 2.将'#'key值排列在A~Z的末尾! 3. 修复优化其他BUG
* 2016.09.24(tag:0.1.5)--适配Swift3
* 2016.09.18(tag:0.1.1)--修复可能造成崩溃的Bug
* 2016.09.17(tag:0.1.0)--Pods初始化

##联系方式:
* Weibo : @CoderPang
* Email : jkpang@outlook.com
* QQ群 : 323408051

![PP-iOS学习交流群群二维码](https://github.com/jkpang/PPCounter/blob/master/PP-iOS%E5%AD%A6%E4%B9%A0%E4%BA%A4%E6%B5%81%E7%BE%A4%E7%BE%A4%E4%BA%8C%E7%BB%B4%E7%A0%81.png)

##许可证
PPGetAddressBookSwift 使用 MIT 许可证，详情见 LICENSE 文件。




