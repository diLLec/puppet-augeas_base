require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
# Publishing tasks
unless RUBY_VERSION =~ /^1\./
  require 'puppet_blacksmith'
  require 'puppet_blacksmith/rake_tasks'
end

exclude_paths = %w(
  pkg/**/*
  vendor/**/*
  .vendor/**/*
  spec/**/*
  contrib/**/*
)

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
  config.disable_checks = ['140chars']
  config.fail_on_warnings = true
end

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

RSpec::Core::RakeTask.new(:serverspec_local) do |t|
  t.rspec_opts = ['--color']
  t.pattern = 'spec/acceptance'
end

task :serverspec_local do
  Rake::Task[:serverspec_local].invoke
end