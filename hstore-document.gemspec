# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: hstore-document 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "hstore-document"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Roman Shterenzon"]
  s.date = "2014-09-26"
  s.description = "Allows embedding documents in ActiveRecord models using PostgreSQL HStore"
  s.email = "roman.shterenzon@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "hstore-document.gemspec",
    "lib/active_record/associations/builder/embeds_one.rb",
    "lib/active_record/associations/embeds_one_association.rb",
    "lib/active_record/embeds_reflection.rb",
    "lib/hstore-document.rb",
    "lib/hstore/document.rb",
    "lib/hstore/fields.rb",
    "lib/hstore/railtie.rb",
    "spec/document_spec.rb",
    "spec/integration_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/models.rb"
  ]
  s.homepage = "http://github.com/romanbsd/hstore-document"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Embedded documents using HStore"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pg>, [">= 0"])
      s.add_runtime_dependency(%q<pg-hstore>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, ["< 5", ">= 3.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>, [">= 0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
    else
      s.add_dependency(%q<pg>, [">= 0"])
      s.add_dependency(%q<pg-hstore>, [">= 0"])
      s.add_dependency(%q<activerecord>, ["< 5", ">= 3.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<pry-byebug>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<pg>, [">= 0"])
    s.add_dependency(%q<pg-hstore>, [">= 0"])
    s.add_dependency(%q<activerecord>, ["< 5", ">= 3.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<pry-byebug>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
  end
end

