Pod::Spec.new do |s|
s.name             = 'ContentstackPersistenceRealm'
s.version          = '0.1.1'
s.summary          = 'iOS persistence library to save app data on device local storage.'

s.license = {
:type => 'MIT',
:file => 'LICENSE'
}

s.description      = <<-DESC
Contentstack is a headless CMS with an API-first approach that puts content at the centre. It is designed to simplify the process of publication by separating code from content. 
In a world where content is consumed via countless channels and form factors across mobile, web and IoT. Contentstack reimagines content management by decoupling code from content. Business users manage content – no training or development required. Developers can create cross-platform apps and take advantage of a headless CMS that delivers content through APIs. With an architecture that’s extensible – but without the bloat of legacy CMS – Contentstack cuts down on infrastructure, maintenance, cost and complexity.
DESC

s.homepage         = 'https://www.contentstack.com/'
s.license          = { :type => 'Commercial',:text => 'See https://www.contentstack.com/'}
s.author           = { 'Contentstack' => 'support@contentstack.io' }
s.source           = { :git => 'https://github.com/contentstack/contentstack-ios-persistence.git', :tag => 'v0.1.1' }
s.social_media_url = 'https://twitter.com/Contentstack'

s.ios.deployment_target = '12.0'
s.dependency 'Contentstack', '~> 3.6'
s.dependency 'ContentstackPersistence', '~> 0.1.1'
s.dependency 'Realm', '~> 4.0'
s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
s.source_files = 'ContentstackPersistenceRealm/*.{h,m}'
s.public_header_files = 'ContentstackPersistenceRealm/*.h'

end
