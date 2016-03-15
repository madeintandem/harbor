source 'https://github.com/CocoaPods/Specs.git'

# platform
platform :osx, '10.10'
use_frameworks!

# build configuration inheritance
xcodeproj 'Harbor', 'Test' => :debug

# harbor 
target 'Harbor' do
  pod 'Alamofire', '~> 3.0'
  pod 'Drip', path: '~/Projects/drip/Drip' #git: 'https://github.com/devmynd/Drip', tag: 'v0.0.1'
end

target 'HarborTests' do
  pod 'Quick', '~> 0.9.0'
  pod 'Nimble', '3.0.0'
end
