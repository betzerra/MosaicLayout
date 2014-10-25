#
# Be sure to run `pod lib lint MosaicLayout.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MosaicLayout"
  s.version          = "0.0.1"
  s.summary          = "A layout very similar to MosaicUI that uses Lightbox algorithm described in @vjeux's blog and takes advantage of UICollectionView."
  s.description      = <<-DESC
                       A layout very similar to MosaicUI that uses Lightbox algorithm described in @vjeux's blog and takes advantage of UICollectionView.

                       * Markdown format.
                       DESC
  s.homepage         = "https://github.com/betzerra/MosaicLayout"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ezequiel Becerra" => "ezequiel.becerra@gmail.com" }
  s.source           = { :git => "https://github.com/betzerra/MosaicLayout.git", :tag => "0.0.1" }
  s.social_media_url = 'https://twitter.com/betzerra'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'MosaicLayout/**/*.{h,m}'
  s.dependency 'AFNetworking', '~> 1.0'
end
