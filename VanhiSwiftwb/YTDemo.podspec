Pod::Spec.new do |s|
  s.name         = "YTDemo"
  s.version      = "0.0.1"
  s.summary      = "我的刷新控件"
  s.homepage     = "https://github.com/Hource/YTDemo"
  s.license      = "MIT"
  s.author             = { "yitao" => "email@address.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/Hource/YTDemo.git", :tag => s.version }
  s.source_files  = "YTDemo", "VanhiSwiftwb/VanhiSwiftwb/Classes/Tools(工具)/UI框架/YTRefreshControl/*.{h,m}"
  s.requires_arc = true

end
