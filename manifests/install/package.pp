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
# * Purges VMware Tools OSP packages
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
class vmwaretools::install::package {

  package { $vmwaretools::params::purge_package_list:
    ensure => $vmwaretools::params::purge_package_ensure,
  }

  if (($vmwaretools::manage_perl_pkgs == true) and (!defined(Package['perl']))) {
    package { 'perl':
      ensure => present,
    }
  }

  if (($vmwaretools::manage_curl_pkgs) and ($vmwaretools::download_vmwaretools == true) and (!defined(Package['curl']))) {
    package { 'curl':
      ensure => present,
    }
  }

  if $vmwaretools::manage_dev_pkgs == true {
    case $::osfamily {
      'Debian' : {
        case $::operatingsystem {
          'Ubuntu' : {
            if ! defined(Package['build-essential']) {
              package{'build-essential':
                ensure => present,
              }
            }
            if ! defined(Package["linux-headers-${::kernelrelease}"]) {
              package{"linux-headers-${::kernelrelease}":
                ensure => present,
              }
            }
          }
          'Debian' : {
            if ! defined(Package["linux-headers-${::kernelrelease}"]) {
              package{"linux-headers-${::kernelrelease}":
                ensure => present,
              }
            }
          }

          default : { fail "${::operatingsystem} not supported yet." }
        }
      }

      'RedHat' : {
        if $vmwaretools::redhat_install_devel == true {
          if ! defined(Package[$vmwaretools::params::redhat_devel_package]) {
            package{$vmwaretools::params::redhat_devel_package:
              ensure => present,
            }
          }
          if ! defined(Package['gcc']) {
            package{'gcc':
              ensure => present,
            }
          }
        }
      }

      default : { fail "${::osfamily} not supported yet." }
    }
  }

}
