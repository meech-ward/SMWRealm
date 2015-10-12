#
# Be sure to run `pod lib lint SMWRealm.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SMWRealm"
  s.version          = "0.1.0"
  s.summary          = "Make it easier to pass around, read, and modify realm objects accross multiple threads."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  SMWRealm uses the primary keys of RMLObjects and thread safe SMWRealmKey objects to easily use RLMObjects accorss multiple threads.
                       DESC

  s.homepage         = "https://github.com/meech-ward/SMWRealm"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Sam Meech-Ward" => "sam@meech-ward.com" }
  s.source           = { :git => "https://github.com/meech-ward/SMWRealm.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SMWRealm' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Realm'
end
