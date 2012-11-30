# == Class: vmwaretools::config
#
# This class handles configuring the vmwaretools module.
#
# == Actions:
#
# Deploys the version-comparison script
#
# === Authors:
#
# Craig Watson <craig@cwatson.org>
#
# === Copyright:
#
# Copyright (C) 2012 Craig Watson
#
class vmwaretools::config {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file {
    $vmwaretools::working_dir:
      ensure => directory;

    "${vmwaretools::working_dir}/version-check.sh":
      source  => 'puppet:///modules/vmwaretools/version-check.sh',
      require => File[$vmwaretools::working_dir];
  }


}
