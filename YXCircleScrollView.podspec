

Pod::Spec.new do |s|



  s.name         = "YXCircleScrollView"
  s.version      = "1.0.0"
  s.summary      = "iOS图片循环滚动轮播视图"

  s.description  = <<-DESC
                      iOS图片循环滚动轮播视图,自动轮播
                   DESC

  s.homepage     = "https://github.com/zhangYongXu/YXCircleScrollView"


  s.license      = "MIT"



  s.author       = { "zhangYongXu" => "577465806@qq.com" }
  

  s.platform     = :ios

 

  s.source       = { :git => "https://github.com/zhangYongXu/YXCircleScrollView.git", :tag => "#{s.version}" }



  s.source_files  = "Classes", "YXCircleScrollView/**/*.{h,m}"

  s.requires_arc = true

 



end
