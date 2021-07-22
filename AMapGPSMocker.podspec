#
# Be sure to run `pod lib lint MAGPSEmulator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMapGPSMocker'
  s.version          = '0.1.0'
  s.summary          = 'GPS的模拟工具，提供单点模拟、多点（路线）回放、坐标系转换等功能'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  GPS的模拟工具，提供单点模拟、多点（路线）回放、坐标系转换等功能,工具实现原理：hook系统CLLocationManager的setDelegate:方法，并将设置的模拟位置塞入到各个定位回调的代理中
                     DESC
  s.homepage         = 'https://github.com/amap-demo/AMapGPSMocker.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xuefeng.lly' => 'xuefeng.lly@autonavi.com' }
  s.source           = { :git => 'https://github.com/amap-demo/AMapGPSMocker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AMapGPSMocker/Classes/**/*.{h,m}'
#  s.public_header_files = 'Pod/Classes/Public/*.h'
  s.resources = ['AMapGPSMocker/Classes/**/*.{xib,storyboard,xcassets}','AMapGPSMocker/Assets/**/*.{xib,storyboard,xcassets,png}']
  s.frameworks = 'UIKit', 'MapKit'
end
