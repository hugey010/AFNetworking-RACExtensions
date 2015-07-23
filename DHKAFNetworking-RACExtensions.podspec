Pod::Spec.new do |s|
  s.name         = "DHKAFNetworking-RACExtensions"
  s.version      = "0.2.2'
  s.summary      = "AFNetworking-RACExtensions is a delightful extension to the AFNetworking classes for iOS and Mac OS X."
  s.homepage     = "http://gitlab.duethealth.com/groups/ios-projects"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Robert Widmann" => "devteam.codafi@gmail.com" }
  s.source       = { :git => "git@gitlab.duethealth.com:ios-projects/afnetworking-racextensions", :tag => s.version }
  s.source_files = 'RACAFNetworking/**/*.{h,m}'
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.dependency 'ReactiveCocoa', '~> 2.5'
  s.dependency 'AFNetworking', '~> 2.5.4'
end
