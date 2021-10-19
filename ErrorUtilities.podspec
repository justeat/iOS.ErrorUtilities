Pod::Spec.new do |s|
  s.name             = 'ErrorUtilities'
  s.version          = '3.0.3'
  s.summary          = 'Errors utilities and protocols'

  s.description      = <<-DESC
Temporary pod containing all the utilities and protocols related to the error handling 
                       DESC

  s.homepage         = 'https://github.com/justeat/iOS.ErrorUtilities'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = 'Just Eat Takeaway iOS Team'
  s.source           = { :git => 'https://github.com/justeat/iOS.ErrorUtilities.git', :tag => s.version.to_s }
  
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.watchos.deployment_target = '4.0'
  s.source_files = 'ErrorUtilities/**/*'
end
