


Pod::Spec.new do |s|

  s.name         = "HLHJAnswerSDK"
  s.version      = "1.0.1"

  s.summary      = "答题答题答题答题"
  s.description  = <<-DESC
                   "答题答题答题答题"
                   DESC

  s.platform =   :ios, "9.0"
  s.ios.deployment_target = "9.0"

  s.homepage     = "https://github.com/zaijianrumo/HLHJAnswerSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "zaijianrumo" => "2245190733@qq.com" }
  s.source       = { :git => "https://github.com/zaijianrumo/HLHJAnswerSDK.git", :tag => "1.0.1"}

  s.xcconfig = {'VALID_ARCHS' => 'arm64 x86_64'}

  s.dependency            "AFNetworking"
  s.dependency            "IQKeyboardManager"
  s.dependency            "Masonry"
  s.dependency            "SDWebImage"
  s.dependency            "SVProgressHUD"
  s.dependency            "YYModel"
  s.dependency            "TMUserCenter"


  s.source_files           = "HLHJFramework/HLHJAnswerSDK.framework/Headers/*.{h,m}"
 s.resources              =  "HLHJFramework/HLHJAnswerResouce.bundle"


end
