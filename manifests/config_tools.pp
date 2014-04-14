# == Class: vmwaretools::config_tools
#
# This class handles running the 'vmware-config-tools' command.
#
# == Actions:
#
# Executes '/usr/bin/vmware-config-tools.pl -d'
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
class vmwaretools::config_tools {

  if $vmwaretools::params::deploy_files {
    Exec['vmware_config_tools'] {
      require => Exec['clean_vmwaretools'],
    }
  }

  exec { 'vmware_config_tools':
    command => '/usr/bin/vmware-config-tools.pl -d',
    creates => $vmwaretools::params::config_creates_real,
  }

}
