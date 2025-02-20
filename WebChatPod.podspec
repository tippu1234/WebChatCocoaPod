#
# Be sure to run `pod lib lint WebChatPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WebChatPod'
  s.version          = '1.0.6'
  s.summary          = 'WebChat Demo Pod'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/tippu1234/WebChatCocoaPod.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tippu1234' => 'tippu.openstream@gmail.com' }
  s.source           = { :git => 'https://github.com/tippu1234/WebChatCocoaPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'WebChatPod/Classes/**/*.swift'
  
  #s.pod_target_xcconfig = {
  #  'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64 armv7 arm64',
  # 'VALID_ARCHS' => 'x86_64 armv7 arm64',
  #}
 # s.user_target_xcconfig = {
   # 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64 armv7 arm64',
   # 'VALID_ARCHS' => 'x86_64 armv7 arm64',
  #}

  s.resource_bundles = {
    'WebChatPod' => [
      'Classes/Files/evawebchat/**/*.{png,xml,scxml,xsd,svg,txt,html,css}',
    ]
  }
  

  s.resources = [
    "WebChatPod/Classes/**/*.xib",
#    "WebChatPod/Classes/evawebchat/**/*",
#    "WebChatPod/Classes/**/*.js",
#    "WebChatPod/Classes/**/*.png",
#    "WebChatPod/Classes/**/*.svg",
#    "WebChatPod/Classes/**/*.xsd",
#    "WebChatPod/Classes/**/*.xml",
#    "WebChatPod/Classes/**/*.scxml",
#    "WebChatPod/Classes/**/*.html",
#    "WebChatPod/Classes/**/*.css",
#    "WebChatPod/Classes/**/*.txt"
  ]


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
