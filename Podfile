# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

abstract_target 'KOMvvmSampleBase' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'SwiftLint', '~> 0.34'
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod 'KOInject', '~> 1.0'
  
  abstract_target 'Logic' do
    pod 'Alamofire', '~> 4.8'
    pod 'RxAlamofire', '~> 5.0'
    
    # Pods for KOMvvmSampleLogic
    target 'KOMvvmSampleLogic' do
    end
    
    # Pods for KOMvvmSampleLogic
    target 'KOMvvmSampleLogicTests' do
      pod 'RxBlocking', '~> 5.0'
      pod 'RxTest', '~> 5.0'
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
