Pod::Spec.new do |s|

s.name         = "XQProjectTool"      #SDK名称
s.version      = "1.9"#版本号
s.homepage     = "https://github.com/SyKingW/XQProjectTool"  #工程主页地址
s.summary      = "一些项目里面要用到的’小公举’."  #项目的简单描述
s.license     = "MIT"  #协议类型
s.author       = { "王兴乾" => "1034439685@qq.com" } #作者及联系方式
s.platform     = :ios, "9.0" #平台及版本
s.ios.deployment_target = "9.0"#最低系统版本
s.source       = { :git => "https://github.com/SyKingW/XQProjectTool.git" ,:tag => "#{s.version}"}   #工程地址及版本号
s.requires_arc = true   #是否必须arc

s.source_files = 'XQProjectTool/Tool/**/*.{h,m,mm}', 'XQProjectTool/UITool/**/*.{h,m,mm}'


#关联资源
s.resources = 'XQProjectTool/UITool/**/*.{xib}'



#依赖的第三方库
s.dependency "Masonry" 

#关联系统framework, 后缀不要
s.frameworks = "UIKit", "AVFoundation"

end
