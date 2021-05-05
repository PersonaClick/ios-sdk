
Pod::Spec.new do |s|
  s.name             = 'PersonaClick'
  s.version          = '1.5.6'
  s.summary          = 'PersonaClick iOS SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is iOS SDK for PersonaClick platform. Read documentation here: https://github.com/PersonaClick/ios-sdk
                       DESC

  s.homepage         = 'https://github.com/PersonaClick/ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PersonaClick' => '«support@personaclick.com»' }

  s.source       = { :git => "https://github.com/PersonaClick/ios-sdk.git", :branch => "master",
  :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'PersonaClick/Classes/**/*'
  s.swift_version = '5'

end
