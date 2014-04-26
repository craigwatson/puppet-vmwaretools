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

  $config_creates_default = "/lib/modules/${::kernelrelease}/misc/vmci.ko"

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

  if $vmwaretools::config_creates == undef {

    $config_creates_real = $::osfamily ? {
      'RedHat' => "/lib/modules/${::kernelrelease}/weak-updates/vmware-tools-vmci/vmci.ko",
      'Debian' => $::operatingsystem ? {
        'Ubuntu' => $::lsbdistcodename ? {
          'lucid' => $config_creates_default,
          default => "/lib/modules/${::kernelrelease}/kernel/drivers/misc/vmw_vmci/vmw_vmci.ko",
        },
        default => $config_creates_default,
      },
      default  => $config_creates_default,
    }

  } else {
    $config_creates_real = $vmwaretools::config_creates
  }

  $awk_path = $::osfamily ? {
    'RedHat' => '/bin/awk',
    'Debian' => '/usr/bin/awk',
    default  => '/usr/bin/awk',
  }

}
