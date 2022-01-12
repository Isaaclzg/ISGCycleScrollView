#
# Be sure to run `pod lib lint ISGCycleScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ISGCycleScrollView'
  s.version          = '1.0.4'
  s.summary          = 'ISGCycleScrollView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  自定义蒙版
                       DESC

  s.homepage         = 'https://github.com/isaaclzg/ISGCycleScrollView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'isaaclzg' => 'isaac_gang@163.com' }
  s.source           = { :git => 'https://github.com/isaaclzg/ISGCycleScrollView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.jianshu.com/u/7e1b920cdac1'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ISGCycleScrollView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ISGCycleScrollView' => ['ISGCycleScrollView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SDWebImage', '>= 5.0.0'
  s.dependency 'TAPageControl', '>= 0.2.0'
  s.dependency 'SDAutoLayout', '>= 2.2.1'
end
