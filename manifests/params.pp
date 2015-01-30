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
# Copyright (C) Craig Watson
# Published under the Apache License v2.0
#
class vmwaretools::params {

  if $::vmwaretools_version == 'not installed' {
    # If nothing is installed, deploy.
    $deploy_files = true
  } else {

    # If tools are installed, are we handling downgrades or upgrades?
    if $vmwaretools::prevent_downgrade {

      if versioncmp($vmwaretools::version,$::vmwaretools_version) < 0 {
        # Do not deploy if the Puppet version is lower than the installed version
        $deploy_files = false
      }
    }

    if $vmwaretools::prevent_upgrade {

      if versioncmp($vmwaretools::version,$::vmwaretools_version) > 0 {
        # Do not deploy if the Puppet version is higher than the installed version
        $deploy_files = false
      }
    }

    if $deploy_files == undef {

      # If tools are installed and we're not preventing a downgrade or upgrade, deploy on version mismatch
      $deploy_files = $::vmwaretools_version ? {
        $vmwaretools::version => false,
        default               => true,
      }
    }
  }

  $awk_path = $::osfamily ? {
    'RedHat' => '/bin/awk',
    'Debian' => '/usr/bin/awk',
    default  => '/usr/bin/awk',
  }

  # Workaround for 'purge' bug on RH-based systems
  # https://projects.puppetlabs.com/issues/2833
  # https://projects.puppetlabs.com/issues/11450
  # https://tickets.puppetlabs.com/browse/PUP-1198
  $purge_package_ensure = $::osfamily ? {
    'RedHat' => absent,
    default  => purged,
  }

  if $::osfamily == 'RedHat' and $::lsbmajdistrelease == '5' {
    if ('PAE' in $::kernelrelease) {
      $kernel_extension = regsubst($::kernelrelease, 'PAE$', '')
      $redhat_devel_package = "kernel-PAE-devel-${kernel_extension}"
    } elsif ('xen' in $::kernelrelease) {
      $kernel_extension = regsubst($::kernelrelease, 'xen$', '')
      $redhat_devel_package = "kernel-xen-devel-${kernel_extension}"
    } else {
      $redhat_devel_package = "kernel-devel-${::kernelrelease}"
    }
  } else {
    $redhat_devel_package = "kernel-devel-${::kernelrelease}"
  }

  $purge_package_list = ['open-vm-tools', 'open-vm-dkms', 'vmware-tools-services', 'vmware-tools-foundation', 'open-vm-tools-desktop']
}
