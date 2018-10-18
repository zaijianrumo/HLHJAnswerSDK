


Pod::Spec.new do |s|

  s.name         = "HLHJAnswerSDK"
  s.version      = "1.0.0"

  s.summary      = "答题答题答题答题"
  s.description  = <<-DESC
                   "答题答题答题答题"
                   DESC

  s.platform =   :ios, "9.0"
  s.ios.deployment_target = "8.0"

  s.homepage     = "https://github.com/zaijianrumo/HLHJAnswerSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "zaijianrumo" => "2245190733@qq.com" }
  s.source       = { :https://github.com/zaijianrumo/HLHJAnswerSDK.git", :tag => "1.0.0"  }


  s.dependency            "AFNetworking","~>3.2.1"
  s.dependency            "IQKeyboardManager","~>6.1.1"
  s.dependency            "Masonry","~>1.1.0"
  s.dependency            "SDWebImage","~>4.4.2"
  s.dependency            "SVProgressHUD","~>2.2.5"
  s.dependency            "YYModel","~>1.0.4"


  s.source_files           = "HLHJAnswerSDK/*"

 # s.frameworks = "TMSDK", "SetI001","UMSocialCore","UShareUI","TMShare","UMSocialNetwork"
  #s.resources          = "HLHJProjectSDK/HLHJSpecialTopicsResource.bundle"



end
