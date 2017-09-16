Pod::Spec.new do |s|
  s.name             = 'CCChainKit'
  s.version          = '0.2.0'
  s.summary          = 'CCChainKit.'

  s.description      = <<-DESC
    A development kit with chain reaction .
                       DESC

  s.homepage         = 'https://github.com/VArbiter/CCChainKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ElwinFrederick' => 'elwinfrederick@163.com' }
  s.source           = { :git => 'https://github.com/VArbiter/CCChainKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  # s.source_files = 'CCChainKit/Classes/**/*'

  # s.resource_bundles = {
  #   'CCChainKit' => ['CCChainKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = "Foundation"

  s.default_subspec = 'CCCore'

  s.subspec 'CCCore' do |coreT|
    coreT.source_files = 'CCChainKit/Classes/*.h'
    coreT.dependency 'CCChainKit/CCData'
    coreT.dependency 'CCChainKit/CCView'
    coreT.dependency 'CCChainKit/CCRuntime'
    # coreT.dependency 'CCChainKit/CCChainAssets'
  end

  s.subspec 'CCFull' do |fullT|
    fullT.dependency 'CCChainKit/CCCore'
    fullT.dependency 'CCChainKit/CCDataBase'
    fullT.dependency 'CCChainKit/CCRouter'
    fullT.dependency 'CCChainKit/CCData'
    fullT.dependency 'CCChainKit/CCView'
    fullT.dependency 'CCChainKit/CCCustom'
  end

  # preserve for future needs
  # s.subspec 'CCChainAssets' do |assets|
    # assets.resource_bundles = {
    #   'CCChainKit' => ['CCChainKit/Classes/CCChainAssets/*']
    # }
  # end

  s.subspec 'CCCommon' do |common|
    common.source_files = 'CCChainKit/Classes/CCChainOperate/CCCommon/**/*'
    common.frameworks = "Foundation", "UIKit", "AssetsLibrary" , "Photos" , "AVFoundation"
  end

  s.subspec 'CCProtocol' do |protocol|
    protocol.source_files = 'CCChainKit/Classes/CCChainOperate/CCProtocol/**/*'
    protocol.dependency 'CCChainKit/CCCommon'
  end

  s.subspec 'CCRuntime' do |runtime|
    runtime.source_files = 'CCChainKit/Classes/CCChainOperate/CCRuntime/**/*'
  end

  s.subspec 'CCDataBase' do |dataBase|
    dataBase.source_files = 'CCChainKit/Classes/CCChainOperate/CCDataBase/**/*'
    dataBase.dependency 'Realm', '~> 2.10.0'
    dataBase.frameworks = "Foundation"
  end

  s.subspec 'CCRouter' do |router|
    router.source_files = 'CCChainKit/Classes/CCChainOperate/CCRouter/**/*'
    router.frameworks = "Foundation"
    router.dependency 'MGJRouter', '~> 0.9.3'
  end

  s.subspec 'CCData' do |data|
    data.source_files = 'CCChainKit/Classes/CCChainOperate/CCData/**/*'
    data.dependency 'CCChainKit/CCProtocol'
    data.dependency 'CCChainKit/CCCommon'
    data.frameworks = "MobileCoreServices"
  end

  s.subspec 'CCView' do |view|
    view.source_files = 'CCChainKit/Classes/CCChainOperate/CCView/**/*'
    view.frameworks = "CoreGraphics" , "QuartzCore" , "WebKit" ,"Accelerate" , "CoreImage"
    view.dependency 'CCChainKit/CCProtocol'
    view.dependency 'CCChainKit/CCCommon'
  end

  s.subspec 'CCCustom' do |custom|
    custom.source_files = 'CCChainKit/Classes/CCChainOperate/CCCustom/**/*'
    custom.dependency 'CCChainKit/CCCore'
    custom.dependency 'AFNetworking/Reachability', '~> 3.1.0'
    custom.dependency 'AFNetworking/UIKit', '~> 3.1.0'
    custom.dependency 'SDWebImage', '~> 4.1.0'
    custom.dependency 'MJRefresh', '~> 3.1.12'
    custom.dependency 'MBProgressHUD', '~> 1.0.0'
    custom.frameworks = "SystemConfiguration" , "CoreTelephony" , "MobileCoreServices", "ImageIO"
  end

end
