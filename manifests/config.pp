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
# Copyright (C) 2013 Craig Watson
# Published under the GNU General Public License v3
#
class vmwaretools::config {

  file { $vmwaretools::working_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

}
