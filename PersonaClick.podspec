
Pod::Spec.new do |s|
  s.name                        = 'PersonaClick'
  s.version                     = '3.5.0'

  s.summary                     = 'PersonaClick SDK for iOS platform - the wide toolset for eCommerce apps. This SDK can be used to integrate in your own app for iOS in few steps.'
  s.readme                      = 'https://reference.api.personaclick.com/#{spec.version.to_s}/README.md'

  s.description                 = <<-DESC
                                For detailed information on methods, please refer to the documentation available at the following link: https://personaclick.atlassian.net/wiki/spaces/english/overview?mode=global
                                DESC

  s.homepage                    = 'https://reference.api.personaclick.com/'
  s.social_media_url            = 'https://personaclick.com/'
  s.license                     = { :type => 'MIT', :file => 'LICENSE' }
  s.author                      = { 'PersonaClick' => '«support@personaclick.com»' }

  s.source                      = { :git => "https://github.com/PersonaClick/ios-sdk.git", :branch => "master",
                                :tag => s.version.to_s }

  s.ios.deployment_target       = '11.0'

  s.source_files                = 'PersonaClick/Classes/**/*.{swift}'
  s.resources                   = 'PersonaClick/**/*.{xcassets,xib,json,png}'

  s.swift_version = '5'

end
