use_frameworks!
inhibit_all_warnings!
platform :ios, '10.0'

target 'ProvisioningFlow' do

    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
end

# RxTests and RxBlocking make the most sense in the context of unit/integration tests
#target 'YOUR_TESTING_TARGET' do
    #pod 'RxBlocking', '~> 3.0'
    #pod 'RxTest',     '~> 3.0'
#end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end