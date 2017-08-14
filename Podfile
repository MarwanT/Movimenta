# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Movimenta' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Keys
  plugin 'cocoapods-keys', {
    :project => "Movimenta",
    :keys => [
    "MovimentaAPIBaseURL",
    "MovimentaEnvironment",
    "MovimentaFacebookAppDisplayName",
    "MovimentaFacebookAppId",
    "MovimentaGoogleAnalyticsIdentifier",
    "MovimentaGoogleAPIKey"
    ]
  }

  # Pods for Movimenta
  pod 'Crashlytics', '3.8.5'
  pod 'Fabric', '1.6.12'
  pod 'FacebookCore', '0.2.0'
  pod 'FacebookLogin', '0.2.0'
  pod 'FacebookShare', '0.2.0'
  pod 'FBSDKCoreKit', '~> 4.22.1'
  pod 'FBSDKLoginKit', '~> 4.22.1'
  pod 'FBSDKShareKit', '~> 4.22.1'
  pod 'Firebase/Core', '4.0.4'
  pod 'GoogleAnalytics', '3.17.0'
  pod 'GoogleMaps', '2.3.1'
  pod 'GooglePlaces', '2.3.1'
  pod 'Moya', '8.0.5'
  pod 'SDWebImage', '4.0.0'
  pod 'SnapKit', '3.2.0'
  pod 'SwiftyJSON', '3.1.4'
  pod 'TTTAttributedLabel', '2.0.0'
  
  target 'MovimentaTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
