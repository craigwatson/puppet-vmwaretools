# == Class: vmwaretools::install
#
# Top-level vmwaretools installation class
#
# == Actions:
#
# Includes the archive/package/exec installation submodules
#
# === Authors:
#
# Craig Watson <craig@cwatson.org>
#
# === Copyright:
#
# Copyright (C) Craig Watson
# Published under the Apache License v2.0
#
class vmwaretools::install {

  include vmwaretools::install::package

  if $vmwaretools::params::deploy_files == true {

    file { $vmwaretools::working_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }

    class { 'vmwaretools::install::archive':
      require => [Class['vmwaretools::install::package'],File[$vmwaretools::working_dir]],
    }

    class { 'vmwaretools::install::exec':
      require => Class['vmwaretools::install::archive'],
    }

  }
}
