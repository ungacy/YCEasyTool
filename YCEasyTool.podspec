#
# Be sure to run `pod lib lint YCEasyTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YCEasyTool'
  s.version          = '0.2.1'
  s.summary          = 'A set of tools.'

  s.description      = <<-DESC
# A set of tools.

## Utils

- Polling

## Runtime

- Property

## Persistence

- Forever

## UI

- TreeMenu

- Segment

- PopMenu

- TabBarController

- GridView

                       DESC

  s.homepage         = 'https://github.com/ungacy/YCEasyTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ye Tao' => 'ungacy@126.com' }
  s.source           = { :git => 'https://github.com/ungacy/YCEasyTool.git', :tag => s.version.to_s }
  s.social_media_url = 'https://ungacy.github.io'

  s.ios.deployment_target = '8.0'

  s.subspec 'Polling' do |ss|
    ss.source_files = 'YCEasyTool/Classes/PollingEntity/*'
	ss.public_header_files = 'YCEasyTool/Classes/PollingEntity/*.h'
  end
  
  s.subspec 'Tools' do |ss|
    ss.source_files = 'YCEasyTool/Classes/Tools/*'
	ss.public_header_files = 'YCEasyTool/Classes/Tools/*.h'
  end
  
  s.subspec 'Property' do |ss|
    ss.source_files = 'YCEasyTool/Classes/Property/*'
	ss.public_header_files = 'YCEasyTool/Classes/Property/*.h'
  end
  
  s.subspec 'Forever' do |ss|
    ss.source_files = 'YCEasyTool/Classes/Forever/*'
	ss.public_header_files = 'YCEasyTool/Classes/Forever/*.h'
	ss.libraries = 'z', 'sqlite3'
	ss.dependency 'YCEasyTool/Property'
  end
  
  s.subspec 'UI' do |ui|
    ui.subspec 'TreeMenu' do |ss|
      ss.source_files = 'YCEasyTool/Classes/UI/TreeMenu/*'
  	  ss.public_header_files = 'YCEasyTool/Classes/UI/TreeMenu/*.h'
    end
  
    ui.subspec 'Segment' do |ss|
      ss.source_files = 'YCEasyTool/Classes/UI/Segment/*'
  	  ss.public_header_files = 'YCEasyTool/Classes/UI/Segment/*.h'
    end
  
    ui.subspec 'TabBarController' do |ss|
      ss.source_files = 'YCEasyTool/Classes/UI/TabBarController/*'
  	  ss.public_header_files = 'YCEasyTool/Classes/UI/TabBarController/*.h'
    end
  
    ui.subspec 'PopMenu' do |ss|
      ss.source_files = 'YCEasyTool/Classes/UI/PopMenu/*'
  	  ss.public_header_files = 'YCEasyTool/Classes/UI/PopMenu/*.h'
    end
	
    ui.subspec 'CollectionView' do |ss|
      ss.source_files = 'YCEasyTool/Classes/UI/CollectionView/*'
  	  ss.public_header_files = 'YCEasyTool/Classes/UI/CollectionView/*.h'
    end
	
    ui.subspec 'Grid' do |ss|
      ss.source_files = 'YCEasyTool/Classes/UI/Grid/*'
  	  ss.public_header_files = 'YCEasyTool/Classes/UI/Grid/*.h'
	  ss.dependency 'YCEasyTool/UI/CollectionView'
	  ss.dependency 'YCEasyTool/Tools'
    end
	
  end
  
end
