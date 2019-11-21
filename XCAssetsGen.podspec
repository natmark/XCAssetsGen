Pod::Spec.new do |s|
  s.name             = 'XCAssetsGen'
  s.version          = '0.1.3'
  s.summary          = 'The swift code generator for asset resources from .xcassets'
  s.description      = <<-DESC
The swift code generator for asset resources from .xcassets written in Swift🐧.
                       DESC
  s.homepage         = 'https://github.com/natmark/XCAssetsGen'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'natmark' => 'natmark0918@gmail.com' }
  s.source           = { :git => 'https://github.com/natmark/XCAssetsGen.git', :tag => s.version.to_s }
  s.source = { http: "https://github.com/natmark/XCAssetsGen/releases/download/#{s.version}/xcassetsgen.zip" }
  s.preserve_paths = '*'
end
