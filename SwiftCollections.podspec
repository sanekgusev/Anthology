#
# Be sure to run `pod lib lint SwiftCollections.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftCollections"
  s.version          = "0.1.0"
  s.summary          = "Exotic collections for Swift"

  s.description      = <<-DESC
  A generic collections library for Swift.
                       DESC

  s.homepage         = "https://github.com/sanekgusev/SwiftCollections"
  s.license          = 'MIT'
  s.author           = { "Alexander Gusev" => "sanekgusev@gmail.com" }
  s.source           = { :git => "https://github.com/sanekgusev/SwiftCollections.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sanekgusev'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.subspec "OrderedDictionary" do |sp|
    sp.source_files = "Pod/Classes/OrderedDictionary.swift"
  end
end
