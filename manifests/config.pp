# == Class: vmwaretools::config
#
# This class handles configuring the vmwaretools module.
#
# == Actions:
#
# Creates the working directory
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
class vmwaretools::config {

  if $vmwaretools::params::deploy_files {
    file { $vmwaretools::working_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }
  }

}
