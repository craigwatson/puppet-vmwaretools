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

  ensure_packages([$::vmwaretools::params::purge_package_list], {'ensure' => $::vmwaretools::params::purge_package_ensure})

  if $::vmwaretools::manage_perl_pkgs == true {
    ensure_packages(['perl'], {'ensure' => 'present'})
  }

  if ($::vmwaretools::manage_curl_pkgs == true) and ($::vmwaretools::params::download_vmwaretools == true) {
    ensure_packages(['curl'], {'ensure' => 'present'})
  }

  if $::vmwaretools::manage_dev_pkgs == true {
    case $::osfamily {
      'Debian' : {
        case $::operatingsystem {
          'Ubuntu' : {
            ensure_packages(['build-essential',"linux-headers-${::kernelrelease}"], {'ensure' => 'present'})
          }
          'Debian' : {
            ensure_packages(["linux-headers-${::kernelrelease}"], {'ensure' => 'present'})
          }
          default : { fail "${::operatingsystem} not supported yet." }
        }
      }

      'RedHat' : {
        if $::vmwaretools::install_devel == true {
          ensure_packages([$vmwaretools::params::redhat_devel_package,'gcc'], {'ensure' => 'present'})
        }
      }

      'Suse'   : {
        if $::vmwaretools::install_devel == true {
          ensure_packages(['kernel-source','gcc'], {'ensure' => 'present'})
        }
      }

      default : { fail "${::osfamily} not supported yet." }
    }
  }

}
