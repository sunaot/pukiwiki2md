# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pukiwiki2md/version'

Gem::Specification.new do |spec|
  spec.name          = "pukiwiki2md"
  spec.version       = Pukiwiki2md::VERSION
  spec.authors       = ["sunaot"]
  spec.email         = ["sunao.tanabe@gmail.com"]

  spec.summary       = %q{A Ruby library for converting PukiWiki notation text to Markdown.}
  spec.description   = %q{Pukiwiki2md is a PEG implementation of PukiWiki parser and transforms PukiWiki notation to Markdown notation.}
  spec.homepage      = "https://github.com/sunaot/pukiwiki2md"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet", "~> 1.8"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "simplecov"
end
