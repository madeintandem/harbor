source 'https://github.com/CocoaPods/Specs.git'

platform :osx, '10.10'
use_frameworks!

target 'Harbor' do
  pod 'Alamofire', '~> 3.0'
  pod 'Drip', path: '~/Projects/drip/Drip' #git: 'https://github.com/devmynd/Drip', tag: 'v0.0.1'
end

def testing_pods
  pod 'Quick', '~> 0.6.0'
  pod 'Nimble', '2.0.0-rc.3'
end

target 'HarborTests' do
  testing_pods
end

target 'HarborUITests' do
  testing_pods
end
