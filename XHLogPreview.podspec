#
# Be sure to run `pod lib lint XHLogPreview.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XHLogPreview'
  s.version          = '1.0.0'
  s.summary          = '使用 CocoaLumberjack 日志,自定义格式,自定义文件名,实现日志预览,分享'
  s.description      = '使用 CocoaLumberjack 日志,自定义格式,自定义文件名,实现日志预览,分享'
  s.homepage         = 'https://github.com/AssassinrKiller/XHLogPreview'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ios_service@126.com' => 'AssassinrKiller' }
  s.source           = { :git => 'https://github.com/AssassinrKiller/XHLogPreview.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'XHLogPreview/Classes/**/*'
  s.dependency 'CocoaLumberjack'
  # s.resource_bundles = {
  #   'XHLogPreview' => ['XHLogPreview/Assets/*.png']
  # }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
end
