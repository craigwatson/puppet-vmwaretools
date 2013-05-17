# == Class: vmwaretools::install::package
#
# This class handles VMware Tools package-related installation duties
#
# == Actions:
#
# * Ensures open-vm-tools is absent - this module directly conflicts.
# * Installs Perl if it hasn't been installed by another module
# * If we're running on a Debian system, install kernel headers and build tools
# * On a Red Hat system and we really want to install kernel headers, do it.
#
# === Authors:
#
# Craig Watson <craig@cwatson.org>
#
# === Copyright:
#
# Copyright (C) 2012 Craig Watson
# Published under the GNU General Public License v3
#
class vmwaretools::install::package {

  package { 'open-vm-tools':
    ensure => purged,
  }

  if (!defined(Package['perl'])) {
    package { 'perl':
      ensure => installed,
    }
  }

  case $::osfamily {

    'Debian' : {
      package { ["linux-headers-${::kernelrelease}",'build-essential'] :
        ensure => present,
      }
    }

    'RedHat' : {
      if $vmwaretools::redhat_install_devel == true {
        package { [ "kernel-devel-${::kernelrelease}", 'gcc' ]:
          ensure => present,
        }
      }
    }

    default : { fail "${::osfamily} not supported yet." }
  }

}
