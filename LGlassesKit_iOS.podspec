Pod::Spec.new do |spec|

  spec.name                     = "LGlassesKit_iOS"
  spec.version                  = "1.0.0"
  spec.summary                  = "LGlassesKit智能眼镜SDK for iOS"
  spec.description              = <<-DESC
                                  LGlassesKit_iOS 为智能眼镜的iOS框架，负责与智能眼镜设备通信等功能的封装。
                                  DESC
  spec.homepage                 = "https://github.com/wsr1949/LGlassesKit_iOS/tree/#{spec.version}/LGlassesKit_iOS"
  spec.license                  = 'MIT'
  spec.author                   = { "wsr1949" => "921903719@qq.com" }
  spec.social_media_url         = 'https://github.com/wsr1949'
  spec.platform                 = :ios, '14.0'
  spec.source                   = { :git => "https://github.com/wsr1949/LGlassesKit_iOS.git", :tag => spec.version.to_s }
  spec.documentation_url        = 'https://github.com/wsr1949/LGlassesKit_iOS/blob/main/README.md'
  spec.requires_arc             = true
  spec.frameworks               = 'CoreBluetooth'
  spec.dependency                 'libopus'

  spec.subspec 'Basic' do |basicSpec|
    basicSpec.vendored_frameworks   = 'XCFramework/LGlassesKit_iOS.xcframework'
  end

  spec.subspec 'JL_OTA' do |jlOtaSpec|
    jlOtaSpec.vendored_frameworks   = 'XCFramework/JL_OTA/JL_OTALib.xcframework', 'XCFramework/JL_OTA/JL_AdvParse.xcframework', 'XCFramework/JL_OTA/JL_HashPair.xcframework', 'XCFramework/JL_OTA/JLLogHelper.xcframework', 'XCFramework/JL_OTA/JL_BLEKit.xcframework', 'XCFramework/JL_OTA/JLBmpConvertKit.xcframework', 'XCFramework/JL_OTA/JLDialUnit.xcframework', 'XCFramework/JL_OTA/JLPackageResKit.xcframework'
  end

  spec.pod_target_xcconfig      = { 
                                    'OTHER_LDFLAGS' => '-lObjC',
                                  }
  
end
