# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'KovaleeSDK' do
    # Comment the next line if you don't want to use dynamic frameworks
    use_frameworks!
    # use_modular_headers!

    # pod 'FirebaseCore', '10.9'
    # pod 'FirebaseAnalyticsSwift', '10.9'
    # pod 'FirebaseCrashlytics', '10.9'
    # pod 'FirebaseRemoteConfig', '10.9'

    # pod 'PromisesSwift', :modular_headers => true
    # pod 'PromisesObjC', :modular_headers => true

    pod 'AppLovinSDK', '11.9.0'
    pod 'AppLovinMediationAdColonyAdapter', '4.9.0.0.4'
    # pod 'AppLovinMediationGoogleAdapter', '10.5.0.0'
    pod 'AppLovinMediationIronSourceAdapter', '7.2.7.0.1'
    pod 'AppLovinMediationFacebookAdapter', '6.12.0.2'
    pod 'AppLovinMediationUnityAdsAdapter', '4.7.1.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
        end
    end
end