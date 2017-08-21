source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place, fake_version = nil)
  if place =~ /^(git[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

group :test do
  gem 'rake',                                                       :require => false
  gem 'puppetlabs_spec_helper', '~> 2.2.0',                         :require => false
  gem 'rspec-puppet', '~> 2.5',                                     :require => false
  gem 'rspec-puppet-facts',                                         :require => false
  gem 'rspec-puppet-utils',                                         :require => false
  gem 'puppet-lint-absolute_classname-check',                       :require => false
  gem 'puppet-lint-alias-check',                                    :require => false
  gem 'puppet-lint-package_ensure-check',                           :require => false
  gem 'puppet-lint-legacy_facts-check',                             :require => false
  gem 'puppet-lint-leading_zero-check',                             :require => false
  gem 'puppet-lint-global_resource-check',                          :require => false
  gem 'puppet-lint-file_source_rights-check',                       :require => false
  gem 'puppet-lint-file_ensure-check',                              :require => false
  gem 'puppet-lint-empty_string-check',                             :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check',  :require => false
  gem 'metadata-json-lint',                                         :require => false
  gem 'puppet-strings', '~> 1.0',                                   :require => false
  gem 'redcarpet',                                                  :require => false
  gem 'rubocop', '~> 0.49.1',                                       :require => false if RUBY_VERSION >= '2.3.0'
  gem 'rubocop-rspec', '~> 1.15.0',                                 :require => false if RUBY_VERSION >= '2.3.0'
  gem 'mocha', '>= 1.2.1',                                          :require => false
  gem 'coveralls',                                                  :require => false
  gem 'simplecov-console',                                          :require => false
  gem 'github_changelog_generator', '~> 1.13.0',                    :require => false if RUBY_VERSION < '2.2.2'
  gem 'rack', '~> 1.0',                                             :require => false if RUBY_VERSION < '2.2.2'
  gem 'github_changelog_generator',                                 :require => false if RUBY_VERSION >= '2.2.2'
  gem 'parallel_tests',                                             :require => false
end

group :development do
  gem 'puppet-blacksmith',        :require => false
  gem 'travis',                   :require => false
  gem 'travis-lint',              :require => false
  gem 'guard-rake',               :require => false
  gem 'overcommit', '>= 0.39.1',  :require => false
end

group :system_tests do
  if beaker_version = ENV['BEAKER_VERSION']
    gem 'beaker', *location_for(beaker_version)
  end
  if beaker_rspec_version = ENV['BEAKER_RSPEC_VERSION']
    gem 'beaker-rspec', *location_for(beaker_rspec_version)
  else
    gem 'beaker-rspec',  :require => false
  end
  gem 'serverspec',                    :require => false
  gem 'beaker-puppet_install_helper',  :require => false
end



if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion.to_s, :require => false, :groups => [:test]
else
gem 'facter', :require => false, :groups => [:test]
end

ENV['PUPPET_VERSION'].nil? ? puppetversion = '~> 5.0' : puppetversion = ENV['PUPPET_VERSION'].to_s
gem 'puppet', puppetversion, :require => false, :groups => [:test]

# vim: syntax=ruby
