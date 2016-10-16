# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pot_markdown/version'

Gem::Specification.new do |spec|
  spec.name = 'pot_markdown'
  spec.version = PotMarkdown::VERSION
  spec.authors = ['ru_shalm']
  spec.email = ['ru_shalm@hazimu.com']

  spec.summary = 'Markdown processor like GitHub'
  spec.homepage = 'https://github.com/rutan/pot_markdown'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'html-pipeline', '~> 2.4'
  spec.add_dependency 'kramdown', '~> 1.12'
  spec.add_dependency 'rouge', '~> 1.8'
  spec.add_dependency 'gemoji'
  spec.add_dependency 'rinku'
  spec.add_dependency 'sanitize'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'diffy'
  spec.add_development_dependency 'rubocop', '0.44.1'
  spec.add_development_dependency 'activesupport'
end
