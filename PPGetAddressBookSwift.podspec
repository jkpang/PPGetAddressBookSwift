Pod::Spec.new do |s|
  s.name         = 'PPGetAddressBookSwift'
  s.version      = "0.2.0"
  s.summary      = "一行代码极速获取按A~Z分组精准排序的通讯录联系人 Swift版( 已处理姓名所有字符的排序问题)"

  s.homepage     = "https://github.com/jkpang/PPGetAddressBookSwift.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "jkpang" => "jkpang@outlook.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/jkpang/PPGetAddressBookSwift.git", :tag => s.version.to_s }

  s.source_files  = "PPGetAddressBookSwift/PPGetAddressBookSwift/*.{swift}"

  s.requires_arc = true

end
