# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'English'

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/cobench/version'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>= 2.2'
  s.name = 'cobench'
  s.version = Cobench::VERSION
  s.license = 'MIT'
  s.metadata = { 'rubygems_mfa_required' => 'true' }
  s.summary = 'Coders Benchmarking Toolkit'
  s.description = 'Downloads statistics from GitHub and builds a nice HTML report'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'http://github.com/yegor256/cobench'
  s.files = `git ls-files`.split($RS)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  s.add_runtime_dependency 'backtrace', '~>0.3'
  s.add_runtime_dependency 'iri', '~>0.5'
  s.add_runtime_dependency 'loog', '~>0.2'
  s.add_runtime_dependency 'nokogiri', '~>1.10'
  s.add_runtime_dependency 'obk', '0.3.0'
  s.add_runtime_dependency 'octokit', '~>6.0'
  s.add_runtime_dependency 'rainbow', '~>3.0'
  s.add_runtime_dependency 'slop', '~>4.4'
end
