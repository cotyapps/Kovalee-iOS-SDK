#
#  Be sure to run `pod spec lint KovaleeAttribution.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "KovaleeAttribution"
  spec.version      = "2.0.0"
  spec.summary      = "KovaleeAttribution automates users attribution."
  spec.description  = <<-DESC
  Measuring marketing effectiveness and understanding where your users come from can be tricky. KovaleeAttribution automates this process, making the identification a breeze.
  It's part of a broader project KovaleeSDK
                   DESC

  spec.license        = { :type => 'MIT', :file => 'MIT-LICENSE' }
  spec.homepage     = "https://github.com/cotyapps/Kovalee-iOS-SDK.git"
  spec.author       = { "fto-k" => "fto@kovalee.app" }

  spec.source       = { :git => "https://github.com/cotyapps/Kovalee-iOS-SDK.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = '14.3'
  spec.swift_version    = '5.7'
  spec.source_files  = "Sources/KovaleeAttribution/*.swift"

  spec.dependency 'KovaleeSDK'
  spec.dependency "Adjust", "~> 5.0.0"

end
