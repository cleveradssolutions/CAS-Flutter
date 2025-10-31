#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint clever_ads_solutions.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'clever_ads_solutions'
  s.version          = '4.4.2'
  s.summary          = 'CAS.AI plugin for Flutter.'
  s.description      = <<-DESC
CAS.AI Mobile Ads plugin for Flutter.
                       DESC
  s.homepage         = 'https://github.com/cleveradssolutions/CAS-Flutter'
  s.authors          = 'Clever Ads Solutions LTD'
  s.license          = { :file => '../LICENSE' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.static_framework = true

  s.dependency 'Flutter'
  s.dependency 'CleverAdsSolutions-Base', '~> 4.4.2'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS' => 'armv7 arm64 x86_64' }
end
