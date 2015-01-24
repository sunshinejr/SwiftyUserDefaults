Pod::Spec.new do |s|
  s.name = 'SwiftyUserDefaults'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Swifty API for NSUserDefaults'
  s.homepage = 'https://github.com/radex/SwiftyUserDefaults'
  s.authors = { 'Radek Pietruszewski' => 'this.is@radex.io' }
  #s.source = { :git => 'https://github.com/radex/SwiftyUserDefaults.git', :tag => '1.0.0' }
  s.source = { :git => 'https://github.com/maximkhatskevich/SwiftyUserDefaults.git', :tag => '1.0.0' }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = '*.swift'
end