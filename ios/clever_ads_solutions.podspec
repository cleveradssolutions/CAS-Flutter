#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint cas.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'clever_ads_solutions'
  s.version          = '0.3.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'CAS.ai' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.source = { :path => 'https://github.com/cleveradssolutions/CAS-Specs.git' }
  s.dependency 'Flutter'
  s.dependency 'CleverAdsSolutions-Base', '~> 3.7.3'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
