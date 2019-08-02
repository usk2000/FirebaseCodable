#
# Be sure to run `pod lib lint FirebaseCodable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FirebaseCodable'
  s.version          = '0.1.0'
  s.summary          = 'Firebase Firestore & Database with Swift Codable'
  s.description      = <<-DESC
Firebase Firestore and Database extension with Swift Codable.
                       DESC

  s.homepage         = 'https://github.com/usk2000/FirebaseCodable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yuusuke Hasegawa' => 'hasegawa.allround@gmail.com' }
  s.source           = { :git => 'https://github.com/usk2000/FirebaseCodable.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  
  s.source_files = 'FirebaseCodable/Classes/**/*'
  s.swift_version = '5.0'
  # s.resource_bundles = {
  #   'FirebaseCodable' => ['FirebaseCodable/Assets/*.png']
  # }

  s.static_framework = true
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Firebase/Firestore', '~> 6'
end
