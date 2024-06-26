#
# Be sure to run `pod lib lint ANNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ANNetwork'
  s.version          = '1.0.5'
  s.summary          = 'A short description of ANNetwork.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sunchengbo/ANNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunchengbo' => '594744124@qq.com' }
  s.source           = { :git => 'https://github.com/sunchengbo/ANNetwork.git', :tag => '1.0.5'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ANNetwork/Classes/**/*'
  s.swift_version = '5.0'

  
  # s.resource_bundles = {
  #   'ANNetwork' => ['ANNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.dependency 'Moya/RxSwift'
  s.dependency 'HandyJSON'
  s.dependency 'ANBaseUI/UserDefaultExtension'
  
end
