Pod::Spec.new do |spec|

  spec.name         = "MaasSDKFramework"
  spec.version      = "1.0.0"
  spec.summary      = "MaasSDK is used to generate both banner ads as well as video ads."

 
  spec.description  = "MaasSdk helps you to show Ads on your player"
  spec.homepage     = "https://github.com/Sanchita-TTN/MaasSDKFramework"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "Sanchita Das Gupta" => "sanchita.gupta@intelivideo.com" }
  spec.platform     = :ios, "11.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  spec.source       = { :git => "https://github.com/Sanchita-TTN/MaasSDKFramework.git", :tag => "1.0.0" }


  spec.source_files  = "MaasSDKFramework"
  #spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

   spec.frameworks  = "UIKit","AVFoundation"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
   spec.dependency "GoogleAds-IMA-iOS-SDK", "~> 3.19.1"

end
