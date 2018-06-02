Pod::Spec.new do |s|

s.name         = "XQProjectTool"      #SDK名称
s.version      = "0.8"#版本号
s.homepage     = "https://github.com/SyKingW/XQProjectTool"  #工程主页地址
s.summary      = "一些项目里面要用到的’小公举’."  #项目的简单描述
s.license     = "MIT"  #协议类型
s.author       = { "王兴乾" => "1034439685@qq.com" } #作者及联系方式
s.platform     = :ios, "9.0" #平台及版本
s.ios.deployment_target = "9.0"#最低系统版本
s.source       = { :git => "https://github.com/SyKingW/XQProjectTool.git" ,:tag => "#{s.version}"}   #工程地址及版本号
s.requires_arc = true   #是否必须arc
s.source_files = 'XQProjectTool/Tool/**/*', 'XQProjectTool/UITool/**/*'   #SDK实际的重要文件路径，这里有个坑，后面文章再说, XQProjectTool/Tool/*.{h,m}这个是表示这个文件夹下面的.hm文件, /**/*.{h,m}

#s.dependency "AFNetworking" #依赖的第三方库
#s.dependency "YYCache"      #依赖的第三方库

#关联系统framework, 后缀不要
s.frameworks = "UIKit"

end
