# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Movimenta' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Keys
  plugin 'cocoapods-keys', {
    :project => "Movimenta",
    :keys => [
    "MovimentaGoogleAnalyticsIdentifier"
    ]
  }

  # Pods for Movimenta
  pod 'Crashlytics', '3.8.5'
  pod 'Fabric', '1.6.12'
  pod 'GoogleAnalytics', '3.17.0'
  pod 'SnapKit', '3.2.0'
  pod 'SwiftyJSON', '3.1.4'
  
  target 'MovimentaTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
