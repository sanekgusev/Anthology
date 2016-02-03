Pod::Spec.new do |s|
  s.name             = "Anthology"
  s.version          = "1.0.1"
  s.summary          = "Exotic Swift collections"
  s.cocoapods_version = '>= 1.0.0.beta2'

  s.description      = <<-DESC
  A collection of less common collections in Swift.
                       DESC

  s.homepage         = "https://github.com/sanekgusev/Anthology"
  s.license          = 'MIT'
  s.author           = { "Aleksandr Gusev" => "sanekgusev@gmail.com" }
  s.source           = { :git => "https://github.com/sanekgusev/Anthology.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sanekgusev'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.subspec "OrderedDictionary" do |od|
    od.source_files = "Sources/Anthology/OrderedDictionary.swift"
  end
  s.subspec "OrderedSet" do |os|
    os.source_files = "Sources/Anthology/OrderedSet.swift"
    os.dependency "Anthology/OrderedDictionary"
  end
end
