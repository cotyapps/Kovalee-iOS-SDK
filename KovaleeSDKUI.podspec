Pod::Spec.new do |s|
  s.name             = 'KovaleeSDKUI'
  s.version          = '2.0.10'
  s.summary          = 'KovaleeSDKUI is an efficient iOS framework, that\'s packed with tools for tracking user behavior.'
  s.description  = <<-DESC
                   KovaleeSDKUI is an efficient iOS framework, that\'s packed with tools specifically for tracking user behavior, handling user purchases, and smoothly integrating ads.
                   DESC

  s.license          = { :type => 'MIT', :file => 'MIT-LICENSE' }
  s.homepage         = 'https://github.com/cotyapps/Kovalee-iOS-SDK'
  s.author           = { 'FT' => 'fto@kovalee.app' }

  s.source           = { :git => 'https://github.com/cotyapps/Kovalee-iOS-SDK.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '15.0'
  s.swift_version    = '5.7'

  s.source_files = 'Sources/KovaleeSDKUI/*.swift', 'Sources/KovaleeSDKUI/Subviews/*.swift'
  s.dependency 'KovaleeSDK'

end
