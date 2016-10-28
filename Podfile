# platform :ios, '9.0'
platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!


target 'tractwork' do
#  pod "Realm"
  pod "RealmSwift", '~> 1.1'
#  pod "Firebase/Core"
#  pod "Firebase/AdMob"
 pod 'PDFGenerator', '~> 2.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

