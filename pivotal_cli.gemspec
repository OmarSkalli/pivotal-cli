# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','pivotal_cli','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'pivotal-cli'
  s.version = PivotalCli::VERSION
  s.author = 'Omar Skalli'
  s.email = 'chetane@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Simple command line tool for working with Pivotal Stories'
  s.homepage = 'https://github.com/chetane/pivotal-cli'
  s.license = 'MIT'
  s.files = `git ls-files`.split($/)
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'pivotal'
  s.add_runtime_dependency('gli','2.11.0')
  s.add_runtime_dependency('rainbow', '2.0.0')
  s.add_runtime_dependency('launchy', '2.4.2')
  s.add_runtime_dependency('highline','1.6.21')
  s.add_runtime_dependency('pivotal-tracker', '0.5.12')
  s.add_runtime_dependency('git', '1.2.8')
end
