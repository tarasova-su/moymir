# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "moymir"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ahmadeeva Svetlana"]
  s.date = "2012-03-14"
  s.email = "ahmadeeva.su@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.homepage = "https://github.com/ahmadeeva-su/moymir"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Mail.ru integration for Rack & Rails application"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ie_iframe_cookies>, ["~> 0.1.2"])
    else
      s.add_dependency(%q<ie_iframe_cookies>, ["~> 0.1.2"])
    end
  else
    s.add_dependency(%q<ie_iframe_cookies>, ["~> 0.1.2"])
  end
end

