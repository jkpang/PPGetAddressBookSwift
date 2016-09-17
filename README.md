# PPGetAddressBookSwift

PPGetAddressBookSwift与Objective-C版本功能与特性相同(基于swift语言的特性,此版本会比OC版性能要好一些).在这里就不多做介绍.

####Objective-C版本,请戳: https://github.com/jkpang/PPGetAddressBook

[简书地址](http://www.jianshu.com/p/b51a6125bcff) ;

![image](https://github.com/jkpang/PPGetAddressBook/blob/master/AddressBook.mov.gif)

##Requirements 要求
* iOS 8+
* Xcode 7.3.1+

##Installation 安装
###1.手动安装:
`下载DEMO后,将子文件夹PPGetAddressBookSwift拖入到项目中,无须import,直接使用`
##Usage 使用方法

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
    self.keysArray = nameKeys       // 所有分组的key值
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

##联系方式:
* Weibo : @CoderPang
* Email : jkpang@outlook.com
* QQ : 2406552315

##许可证
PPGetAddressBookSwift 使用 MIT 许可证，详情见 LICENSE 文件。




