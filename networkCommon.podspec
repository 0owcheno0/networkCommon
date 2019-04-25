#
# Be sure to run `pod lib lint networkCommon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'networkCommon'
  s.version          = '0.0.2'
  s.summary          = '网络请求基础方法'
  s.swift_version    = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/0owcheno0/networkCommon'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wchen' => '1026655179@qq.com' }
  s.source           = { :git => 'https://github.com/0owcheno0/networkCommon.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'networkCommon/Classes/**/*'
  
  # s.resource_bundles = {
  #   'networkCommon' => ['networkCommon/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'MobileCoreServices'
  s.dependency 'SwiftyJSON', '~> 4.0'
  s.dependency 'Alamofire', '~> 4.7.0'
end
