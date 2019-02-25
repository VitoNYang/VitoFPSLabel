Pod::Spec.new do |s|

s.name         = "VitoFPSTrack"
s.version      = "0.2"
s.summary      = "A FPS Tracking Library"

s.description  = <<-DESC
A FPS Tracking Library, you can use it everywhere 🌈
update to swift4.2
DESC

s.homepage     = "https://github.com/VitoNYang/VitoFPSLabel"

s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.author       = { "hao" => "740697612@qq.com" }

s.source       = { :git => "https://github.com/VitoNYang/VitoFPSLabel.git", :tag => "#{s.version}" }
s.platform     = :ios
s.ios.deployment_target = '9.0'
s.source_files = "VitoFPSLabel", "VitoFPSLabel/*{.plist,h,swift}"

end
