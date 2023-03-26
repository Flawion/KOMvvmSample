# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

abstract_target 'KOMvvmSampleBase' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'SwiftLint', '~> 0.50'
  pod 'RxSwift', '~> 6.5'
  pod 'RxCocoa', '~> 6.5'
  pod 'KOInject', '~> 1.0'
  
  abstract_target 'Logic' do
    pod 'Alamofire', '~> 5.6'
    pod 'RxAlamofire', '~> 6.1'
    
    # Pods for KOMvvmSampleLogic
    target 'KOMvvmSampleLogic' do
    end
    
    # Pods for KOMvvmSampleLogic
    target 'KOMvvmSampleLogicTests' do
      pod 'RxBlocking', '~> 6.5'
      pod 'RxTest', '~> 6.5'
    end
  end
  
  abstract_target 'UI' do
    pod 'SDWebImage', '~> 5.0'
    pod 'UIScrollView-InfiniteScroll', '~> 1.1.0'
    pod 'KOControls', '~> 1.2.4'
    
    # Pods for KOMvvmSample
    target 'KOMvvmSample' do
    end
    
  end

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
  end
 end
end
