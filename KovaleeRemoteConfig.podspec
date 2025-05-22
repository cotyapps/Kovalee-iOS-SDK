#
#  Be sure to run `pod spec lint KovaleeRemoteConfig.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "KovaleeRemoteConfig"
  spec.version      = "2.0.10"
  spec.summary      = "KovaleeRemoteConfig simplifies AB testing experiments."
  spec.description  = <<-DESC
  Unsure about how to present a feature? KovaleeRemoteConfig simplifies AB testing, helping you figure out the most user-friendly way to show off your new feature and optimize old ones.
It's part of a broader project KovaleeSDK
                   DESC

  spec.license      = { :type => 'MIT', :file => 'MIT-LICENSE' }
  spec.homepage     = "https://github.com/cotyapps/Kovalee-iOS-SDK.git"
  spec.author       = { "fto-k" => "fto@kovalee.app" }

  spec.source       = { :git => "https://github.com/cotyapps/Kovalee-iOS-SDK.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = '14.3'
  spec.swift_version    = '5.7'
  spec.source_files  = "Sources/KovaleeRemoteConfig/*.swift"

  spec.dependency 'KovaleeSDK'

  spec.static_framework = true

  # spec.dependency 'Firebase/Core', '~> 10.18.0'
  spec.dependency "FirebaseAnalyticsSwift", '~> 10.18.0'
  spec.dependency "FirebaseRemoteConfigSwift", '~> 10.18.0'

end
