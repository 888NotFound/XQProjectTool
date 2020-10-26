Pod::Spec.new do |s|
    
    s.name         = "XQProjectTool"      #SDK名称
    s.version      = "2.0"#版本号
    s.homepage     = "https://github.com/SyKingW/XQProjectTool"  #工程主页地址
    s.summary      = "一些项目里面要用到的’小公举’."  #项目的简单描述
    s.license      = "MIT"  #协议类型
    s.author       = { "王兴乾" => "1034439685@qq.com" } #作者及联系方式
    s.osx.deployment_target  = '10.13'
    s.ios.deployment_target  = "9.0" #平台及版本
    s.source       = { :git => "https://github.com/SyKingW/XQProjectTool.git" ,:tag => "#{s.version}"}   #工程地址及版本号
    s.requires_arc = true   #是否必须arc
    s.prefix_header_file = 'XQProjectTool/XQProjcetToolPrefixHeader.pch'
    
    
    #UITool模块
    s.subspec 'UITool' do |iphoneS|
        iphoneS.ios.deployment_target  = "9.0" #平台及版本
        iphoneS.source_files = 'XQProjectTool/UITool/**/*.{h,m,mm}'
        #关联资源
        #iphoneS.resources = 'XQProjectTool/UITool/**/*.{xib}'
        
        #iphoneS.dependency 'Masonry'
        #关联系统framework, 后缀不要
        iphoneS.frameworks = "UIKit", "AVFoundation"
        iphoneS.dependency "XQProjectTool/Tool"
    end
    
    
    #通用Tool模块
    s.subspec 'Tool' do |toolS|
        toolS.osx.deployment_target  = '10.13'
        toolS.ios.deployment_target  = "9.0" #平台及版本
        toolS.source_files = 'XQProjectTool/Tool/**/*.{h,m,mm}'
        
        toolS.frameworks = "CoreTelephony"
        
    end
    
    
    #MacTool模块
    s.subspec 'MacTool' do |macS|
        macS.platform = :osx, '10.13'
        macS.source_files = 'XQProjectTool/MacTool/**/*.{h,m,mm}'
    end
    
    
    
end






