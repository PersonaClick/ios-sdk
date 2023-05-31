
Pod::Spec.new do |s|
  s.name                        = 'PersonaClick'
  s.version                     = '3.3.9'

  s.summary                     = 'PersonaClick SDK for iOS'
  s.readme                      = 'https://reference.api.personaclick.com/#{spec.version.to_s}/README.md'

  s.description                 = <<-DESC
                                This is PersonaClick SDK for iOS platform.
                                Read documentation here: https://reference.api.personaclick.com/
                                DESC

  s.homepage                    = 'https://reference.api.personaclick.com/'
  s.social_media_url            = 'https://personaclick.com/'
  s.license                     = { :type => 'MIT', :file => 'LICENSE' }
  s.author                      = { 'PersonaClick' => '«support@personaclick.com»' }

  s.source                      = { :git => "https://github.com/PersonaClick/ios-sdk.git", :branch => "master",
                                :tag => s.version.to_s }

  s.ios.deployment_target       = '11.0'

  s.source_files                = 'PersonaClick/Classes/**/*.swift'
  s.resources                   = 'PersonaClick/**/*.{xcassets,json,png}'

  s.swift_version = '5'

end
