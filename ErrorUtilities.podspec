#
# Be sure to run `pod lib lint ErrorUtilities.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ErrorUtilities'
  s.version          = '2.1.3'
  s.summary          = 'Errors utilities and protocols'

  s.description      = <<-DESC
Temporary pod containing all the utilities and protocols related to the error handling 
                       DESC

  s.homepage         = 'https://github.com/justeat/iOS.ErrorUtilities'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.authors          = { 'Just Eat iOS team' => 'justeat.ios.team@gmail.com', 'Federico Cappelli' => 'federico.cappelli@just-eat.com', 'Alberto De Bortoli' => 'alberto.debortoli@just-eat.com' }
  s.source           = { :git => 'git@github.com:justeat/iOS.ErrorUtilities.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.watchos.deployment_target = '4.0'
  s.source_files = 'ErrorUtilities/**/*'
end
