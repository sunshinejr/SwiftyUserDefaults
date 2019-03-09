Pod::Spec.new do |s|
  s.name = 'SwiftyUserDefaults'
  s.version = '4.0.0-beta.2'
  s.license = 'MIT'
  s.summary = 'Swifty API for NSUserDefaults'
  s.homepage = 'https://github.com/radex/SwiftyUserDefaults'
  s.authors = { 'Radek Pietruszewski' => 'this.is@radex.io', 'Łukasz Mróz' => 'thesunshinejr@gmail.com' }
  s.source = { :git => 'https://github.com/radex/SwiftyUserDefaults.git', :tag => s.version }
  
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.swift_version = '4.2'
  s.cocoapods_version = '>= 1.4.0'  

  s.source_files = 'Sources/*.swift'
end
