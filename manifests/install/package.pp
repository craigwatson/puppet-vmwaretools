# == Class: vmwaretools::install::package
#
# This class handles VMware Tools package-related installation duties
#
# == Actions:
#
# * Ensures open-vm-tools is absent - this module directly conflicts.
# * Installs Perl if it hasn't been installed by another module
# * Installs curl if we're using the download script
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

  package { ['open-vm-tools','open-vm-dkms']:
    ensure => purged,
  }

  if !defined(Package['perl']) {
    package { 'perl':
      ensure => present,
    }
  }

  if $vmwaretools::params::archive_url != 'puppet' {
    if !defined(Package['curl']) {
      package { 'curl':
        ensure => installed,
      }
    }
  }

  case $::osfamily {

    'Debian' : {
      if ! defined(Package['build-essential']) {
        package{'build-essential':
          ensure => installed,
        }
      }
      if ! defined(Package["linux-headers-${::kernelrelease}"]) {
        package{"linux-headers-${::kernelrelease}":
          ensure => installed,
        }
      }
    }

    'RedHat' : {
      if $vmwaretools::redhat_install_devel == true {
        if ! defined(Package["kernel-devel-${::kernelrelease}"]) {
          package{"kernel-devel-${::kernelrelease}":
            ensure => installed,
          }
        }
        if ! defined(Package['gcc']) {
          package{'gcc':
            ensure => installed,
          }
        }
      }
    }

    default : { fail "${::osfamily} not supported yet." }
  }

}
