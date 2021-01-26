# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Vilanov' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Vilanov
  
  pod 'PKHUD', '~> 4.0'
#  pod 'SwiftMessages'
#  pod 'RSSelectionMenu'
  pod 'Alamofire', '~> 4.7'
  pod 'SDWebImage'
  pod 'SDWebImage/GIF'
  pod 'PINRemoteImage'
#  pod 'CircleProgressBar'
  pod 'SwiftDate', '~> 5.0'
#  pod 'Eureka'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
#  pod 'GoogleMaps'
#  pod 'GooglePlaces'
#  pod 'Socket.IO-Client-Swift', '~> 13.2.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
        end
    end
end
