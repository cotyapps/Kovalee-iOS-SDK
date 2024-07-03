Pod::Spec.new do |s|
  s.name             = 'KovaleeSDKUI'
  s.version          = '1.9.22'
  s.summary          = 'KovaleeSDKUI is an efficient iOS framework, that\'s packed with tools for tracking user behavior.'
  s.description  = <<-DESC
                   KovaleeSDKUI is an efficient iOS framework, that\'s packed with tools specifically for tracking user behavior, handling user purchases, and smoothly integrating ads.
                   DESC

  s.license          = 'Code is MIT, then custom font licenses.'
  s.homepage         = 'https://github.com/cotyapps/Kovalee-iOS-SDK'
  s.author           = { 'FT' => 'fto@kovalee.app' }

  s.source           = { :git => 'https://github.com/cotyapps/Kovalee-iOS-SDK.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '14.3'
  s.swift_version    = '5.7'

  s.source_files = 'Sources/KovaleeSDKUI/*.swift'
  s.dependency 'KovaleeSDK'

end
