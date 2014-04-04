require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send("disable_80chars")
PuppetSyntax.future_parser = true

task :test => [
  :syntax,
  :lint
]
