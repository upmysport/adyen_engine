# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adyen/version'

Gem::Specification.new do |s|
  s.name    = "adyen_engine"
  s.version = Adyen::VERSION

  s.summary = "Integrate Adyen payment services in your Ruby on Rails application."
  s.description = <<-EOS
    A Rails engine that makes use of the adyen gem, http://github.io/wvanbergen/adyen, to ease
    integration of Adyen within a Rails app.
  EOS

  s.authors  = ['NJ Pearman']
  s.email    = ['n.pearman@gmail.com']
  s.homepage = 'http://github.com/njpearman/adyen_engine'
  s.license  = 'MIT'

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.14')
  s.add_development_dependency('rspec-rails', '~> 2.14')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('factory_girl_rails')

  if RUBY_VERSION < "1.9.3"
    s.add_development_dependency('rails', '>= 2.3', '< 4')
  else
    s.add_development_dependency('rails', '>= 2.3')
  end
  
  if RUBY_PLATFORM == 'java'
    s.add_development_dependency('nokogiri', '~> 1.4.6')
  elsif RUBY_VERSION < "1.9"
    s.add_development_dependency('nokogiri', '~> 1.5.0')
  else
    s.add_development_dependency('nokogiri', '~> 1.6.0')
  end
  
  s.add_runtime_dependency('jruby-openssl') if RUBY_PLATFORM == 'java'
  
  s.requirements << 'Having Nokogiri installed will speed up XML handling when using the SOAP API.'

  s.rdoc_options << '--title' << s.name << '--main' << 'README.rdoc' << '--line-numbers' << '--inline-source'
  s.extra_rdoc_files = ['README.rdoc']

  s.files = `git ls-files`.split($/)
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
end
