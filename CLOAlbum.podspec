
Pod::Spec.new do |s|

  s.name         = "CLOAlbum"
  s.version      = "0.0.1"
  s.summary      = "A short description of CLOAlbum."
  s.description  = <<-DESC
                    Cc
                   DESC

  s.homepage     = "https://github.com/ccloveobjc/CLOAlbum"
  
  s.license      = { :type => 'Copyright', :text =>
        <<-LICENSE
        Copyright 2010-2015 CenterC Inc.
        LICENSE
    }
  
  s.author             = { "TT" => "654974034@qq.com" }
  
  s.source       = { :git => "https://github.com/ccloveobjc/CLOAlbum.git", :tag => "#{s.version}" }

  s.requires_arc = true

  s.default_subspec     = 'Core'

  s.subspec 'Core' do |ss|
    ss.frameworks          = "Photos"
    ss.dependency            'CLOCommon/Core'
    ss.source_files        = "Classes/Core/**/*.{h,m,mm,hpp,cpp,c}"
  end
  s.subspec 'UI' do |ss|
    ss.frameworks          = "UIKit"
    ss.dependency            'CLOAlbum/Core'
    ss.source_files        = "Classes/UI/**/*.{h,m,mm,hpp,cpp,c}"
  end

end
