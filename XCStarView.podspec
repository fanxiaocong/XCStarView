Pod::Spec.new do |s|

  s.name         = "XCStarView"
  s.version      = "1.0.0"
  s.summary      = "XCStarView."

  s.description  = <<-DESC
	XCStarView,评星视图
                   DESC

  s.homepage     = "https://github.com/fanxiaocong/XCStarView"

  s.license      = "MIT"


  s.author             = { "樊小聪" => "1016697223@qq.com" }


  s.platform     = :ios, "8.3"

  s.source       = { :git => "https://github.com/fanxiaocong/XCStarView.git", :tag => "#{s.version}" }

  s.source_files  = "XCStarView/*.{h,m,xib}"
  s.resources = "XCStarView/*.bundle"

end
