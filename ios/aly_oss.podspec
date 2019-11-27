#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'aly_oss'
  s.version          = '0.0.1'
  s.summary          = 'A ALY OSS plugin.'
  s.description      = <<-DESC
A ALY OSS plugin.
                       DESC
  s.homepage         = 'httpq://jitao.tech'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ji Tao' => 'jitao@jitao.tech' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AliyunOSSiOS'

  s.ios.deployment_target = '10.0'
end

