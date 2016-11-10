#
# Be sure to run `pod lib lint DXPopover.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DXPopover"
  s.version          = "0.1.2"
  s.summary          = "A Popover mimic Facebook  app popover using UIKit."
  s.description      = <<-DESC
                       A Popover mimic Facebook  app popover using UIKit.

                       The concept of this popover is very simple: add your contentView in a popover, then show the popover in the container view.
                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/xiekw2010/DXPopover"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "xiekw2010" => "xiekw2010@gmail.com" }
  s.source           = { :git => "https://github.com/xiekw2010/DXPopover.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DXPopover' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
