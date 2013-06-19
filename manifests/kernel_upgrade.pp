# == Class: vmwaretools::kernel_upgrade
#
# This class handles re-compiling VMware Tools after a kernel upgrade.
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
class vmwaretools::kernel_upgrade {

  # The vmxnet3 driver isn't in the same place across every flavor of Linux,
  # so we need to specify where that file is found across the distros.
  case $::osfamily {
    /(?i-mx:debian)/: {
      $vmxnet_driver = "/lib/modules/${::kernelrelease}/kernel/drivers/net/vmxnet3/vmxnet3.ko"
    }
    /(?i-mx:redhat)/: {
      $vmxnet_driver = $::lsbmajdistrelease ? {
        '5' => "/lib/modules/${::kernelrelease}/misc/vmxnet3.ko",
        '6' => "/lib/modules/${::kernelrelease}/kernel/drivers/net/vmxnet3/vmxnet3.ko",
      }
    }
    default: { fail("${::operatingsystem} is unsupported") }
  }

  if $vmwaretools::params::deploy_files {
    Exec['vmware_config_tools'] {
      require => Exec['clean_vmwaretools'],
    }
  }

  exec { 'vmware_config_tools':
    command => '/usr/bin/vmware-config-tools.pl -d',
    creates => $vmxnet_driver,
  }

}
