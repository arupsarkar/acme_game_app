require_relative './mobile_sdk/SalesforceMobileSDK-iOS/mobilesdk_pods'

platform :ios, '15.0'

project 'acme_app.xcodeproj'
target 'acme_app' do
  source 'https://cdn.cocoapods.org/'
  use_frameworks!
  use_mobile_sdk!
end

post_install do |installer|
  # Comment the following if you do not want the SDK to emit signpost events for instrumentation. Signposts are  enabled for non release version of the app.
  signposts_post_install(installer)

  mobile_sdk_post_install(installer)
end