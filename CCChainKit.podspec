Pod::Spec.new do |s|
  s.name             = 'CCChainKit'
  s.version          = '0.0.1'
  s.summary          = 'CCChainKit.'

  s.description      = <<-DESC
    A development kit with chain reaction .
                       DESC

  s.homepage         = 'https://github.com/ElwinFrederick/CCChainKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ElwinFrederick' => 'elwinfrederick@163.com' }
  s.source           = { :git => 'https://github.com/ElwinFrederick/CCChainKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CCChainKit/Classes/**/*'

  # s.resource_bundles = {
  #   'CCChainKit' => ['CCChainKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = "Foundation" , "UIKit" , "AssetsLibrary" , "Photos" , "CoreGraphics" , "QuartzCore" , "SystemConfiguration" , "CoreTelephony" , "MobileCoreServices"
  s.dependency 'MBProgressHUD', '~> 1.0.0'
end
