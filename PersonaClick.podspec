Pod::Spec.new do |s|
  s.name             = 'PersonaClick'
  s.version          = '3.6.62'

  s.summary          = 'PersonaClick SDK for iOS platform - the wide toolset for eCommerce apps. This SDK can be used to integrate in your own app for iOS in few steps.'
  s.readme           = 'https://reference.api.personaclick.com/#{spec.version.to_s}/README.md'

  s.description      = <<-DESC
  PersonaClick SDK for iOS platform - the wide toolset for eCommerce apps:

  - Personalization engine.
  - Product recommendations.
  - Personalized products search engine.
  - Bulk emails, push-notifications, SMS and Telegram messages.
  - Transactional emails, push-notifications, Telegram and SMS.
  - Drip campaigns (email, push, Telegram, SMS).
  - Customizable on-site popups.
  - CRM, CDP and customer segments.
  - Net Promoter Score tool for any goal.
  - Stories.
  - In-app push.
  - Loyalty program.

  You can integrate all PersonaClick tools into your iOS app.
                       DESC


  s.homepage         = 'https://reference.api.personaclick.com/'
  s.social_media_url = 'https://personaclick.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PersonaClick' => '«success@personaclick.com»' }

  s.screenshots = ['https://personaclick.com/static-images/cocoapods/r46_ios_sdk_cocoapods_cover.png']

  s.source           = { :git => "https://github.com/personaClick/ios-sdk.git", :branch => "master" }

  s.ios.deployment_target = '12.0'

  s.source_files     = 'PersonaClick/Classes/**/*.{swift}'
  s.resources        = 'PersonaClick/Classes/Resources/*.{xcassets,xib,storyboard,json,png}'

  s.swift_version = '5'

end
