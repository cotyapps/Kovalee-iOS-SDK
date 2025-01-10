#
#  Be sure to run `pod spec lint KovaleePurchases.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "KovaleePurchases"
  spec.version      = "2.0.0"
  spec.summary      = "KovaleePurchases simplify in-app purchases and subscriptions"
  spec.description  = <<-DESC
  Adding in-app purchases and subscriptions doesn't need to be a headache. KovaleePurchases comes with a set of APIs designed to streamline this integration.
It's part of a broader project KovaleeSDK
                   DESC

  spec.license      = { :type => 'MIT', :file => 'MIT-LICENSE' }
  spec.homepage     = "https://github.com/cotyapps/KovaleePurchases-iOS"
  spec.author       = { "fto-k" => "fto@kovalee.app" }

  spec.source       = { :git => "https://github.com/cotyapps/Kovalee-iOS-SDK.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = '14.3'
  spec.swift_version         = '5.7'
  spec.source_files          = "Sources/KovaleePurchases/*.swift"

  spec.dependency 'KovaleeSDK'
  spec.dependency "RevenueCat", '>= 4.38.0'
  spec.dependency "KovaleeRemoteConfig"

  spec.static_framework = true

  spec.dependency 'Firebase/Core', '>= 10.24.0'
  spec.dependency "FirebaseAnalyticsSwift"
  spec.dependency "FirebaseRemoteConfigSwift"
end
