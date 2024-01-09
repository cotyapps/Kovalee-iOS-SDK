Pod::Spec.new do |s|
  s.name             = 'KovaleeSDK'
  s.version          = '1.5.7'
  s.summary          = 'KovaleeSDK is an efficient iOS framework, that\'s packed with tools for tracking user behavior.'
  s.description  = <<-DESC
                   KovaleeSDK is an efficient iOS framework, that\'s packed with tools specifically for tracking user behavior, handling user purchases, and smoothly integrating ads.
                   DESC

  s.license          = 'Code is MIT, then custom font licenses.'
  s.homepage         = 'https://github.com/cotyapps/Kovalee-iOS-SDK'
  s.author           = { 'FT' => 'fto@kovalee.app' }

  s.source           = { :git => 'https://github.com/cotyapps/Kovalee-iOS-SDK.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '14.3'
  s.swift_version    = '5.7'
  s.source_files     =  "Sources/KovaleeSDK/**/*.swift"

  s.vendored_frameworks = ['Frameworks/KovaleeFramework.xcframework']
  s.dependency 'AmplitudeSwift', '~> 0.7.3'
end
