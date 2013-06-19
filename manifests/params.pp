# == Class: vmwaretools::params
#
# This class handles parameters for the vmwaretools module, including the logic
# that decided if we should install a new version of VMware Tools.
#
# == Actions:
#
# None
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
class vmwaretools::params {

  if $::vmwaretools_version == 'not installed' {
    # If nothing is installed, deploy.
    $deploy_files = true
  } else {

    # If tools are installed, are we handling downgrades?
    if $vmwaretools::prevent_downgrade {

      if versioncmp($::vmwaretools_version,$vmwaretools::version) < 0 {
        # Only deploy if the installed version is **lower than** the Puppet version
        $deploy_files = true
      } else {
        $deploy_files = false
      }

    } else {

      # If we're not handling downgrades, deploy on version mismatch
      $deploy_files = $::vmwaretools_version ? {
        $vmwaretools::version => false,
        default               => true,
      }

    }
  }

  $config_creates = $::osfamily ? {
    'Debian' => "/lib/modules/${::kernelrelease}/kernel/drivers/net/vmxnet3/vmxnet3.ko",
    'RedHat' => $::lsbmajdistrelease ? {
      '5'     => "/lib/modules/${::kernelrelease}/misc/vmxnet3.ko",
      '6'     => "/lib/modules/${::kernelrelease}/kernel/drivers/net/vmxnet3/vmxnet3.ko",
      default => 'unsupported',
    },
    default  => 'unsupported',
  }

  $awk_path = $::osfamily ? {
    'RedHat' => '/bin/awk',
    'Debian' => '/usr/bin/awk',
    default  => '/usr/bin/awk',
  }

}
