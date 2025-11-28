Pod::Spec.new do |s|
    s.name             = 'KovaleeSurvey'
    s.version          = '2.0.10'
    s.summary          = 'KovaleeSurvey is an efficient iOS framework, that\'s packed with tools for tracking user behavior.'
    s.description  = <<-DESC
                     KovaleeSurvey is an efficient iOS framework, that\'s packed with tools specifically for tracking user behavior, handling user purchases, and smoothly integrating ads.
                     DESC
  
    s.license          = { :type => 'MIT', :file => 'MIT-LICENSE' }
    s.homepage         = 'https://github.com/cotyapps/Kovalee-iOS-SDK'
    s.author           = { 'FT' => 'fto@kovalee.app' }
  
    s.source           = { :git => 'https://github.com/cotyapps/Kovalee-iOS-SDK.git', :tag => "#{s.version}" }
  
    s.ios.deployment_target = '15.0'
    s.swift_version    = '5.7'
  
    s.source_files     =  "Sources/KovaleeSurvey/**/*.swift"
    s.dependency 'KovaleeSDK'
    s.dependency 'Survicate', '>= 5.0.0'
  end
