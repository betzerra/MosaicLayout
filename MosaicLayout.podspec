Pod::Spec.new do |s|
  s.name         = "MosaicLayout"
  s.version      = "0.0.1"
  s.summary      = "MosaicLayout using UICollectionViews"
  s.description  = "A layout very similar to MosaicUI that uses Lightbox algorithm described in @vjeux's blog and takes advantage of UICollectionView."

  s.homepage     = "http://github.com/betzerra/MosaicLayout"
  s.screenshots = "https://camo.githubusercontent.com/05e958af928b0dcec951b57764eb1fdbf4f119e9/687474703a2f2f7777772e6265747a657272612e636f6d2e61722f77702d636f6e74656e742f75706c6f6164732f323031332f30322f50686f746f2d4665622d31372d362d32392d31342d504d2e706e67"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Ezequiel Alejandro Becerra" => "ezequiel.becerra@gmail.com" }
  s.social_media_url   = "http://twitter.com/betzerra"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/vinnyoodles/MosaicLayout.git", :tag => "0.0.1" }
  s.source_files  = "MosaicCollectionView/*"
  s.exclude_files = "Classes/Exclude"
end
