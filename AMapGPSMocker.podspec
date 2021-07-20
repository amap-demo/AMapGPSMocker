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
  s.summary          = 'A short description of AMapGPSMocker.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'git@gitlab.alibaba-inc.com:AMapOP-trip/MAGPSEmulator.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xuefeng.lly' => 'xuefeng.lly@autonavi.com' }
  s.source           = { :git => 'git@gitlab.alibaba-inc.com:AMapOP-trip/MAGPSEmulator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AMapGPSMocker/Classes/**/*.{h,m}'
  
  s.resources = ['AMapGPSMocker/Classes/**/*.{xib,storyboard,xcassets}','AMapGPSMocker/Assets/**/*.{xib,storyboard,xcassets,png}']
  s.public_header_files = 'Pod/Classes/Public/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#标记是否依赖导航SDK
  $useNaviSdk = ENV['use_navi_sdk']
#标记内部调试依赖使用
  $internalDebug = ENV['internal_debug']
  if $useNaviSdk
    if $internalDebug
      s.dependency 'AMapFoundationKit'
      s.dependency 'AMapNaviKit'
    else
      s.dependency 'AMapNavi'
    end
  else
    if $internalDebug
      s.dependency 'AMapFoundationKit'
      s.dependency 'MAMapKit'
    else
      s.dependency 'AMap3DMap'
    end
  end
end
