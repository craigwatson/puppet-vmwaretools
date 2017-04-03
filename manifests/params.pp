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
  } elsif versioncmp($::vmwaretools::version,$::vmwaretools_version) == 0 {
    # If versions are the same, do not deploy.
    $deploy_files = false
  } elsif versioncmp($::vmwaretools::version,$::vmwaretools_version) < 0 {
    # Action would be a downgrade
    if $::vmwaretools::prevent_downgrade == true {
      $deploy_files = false
    } else {
      $deploy_files = true
    }
  } elsif versioncmp($::vmwaretools::version,$::vmwaretools_version) > 0 {
    # Action would be an upgrade
    if $::vmwaretools::prevent_upgrade == true {
      $deploy_files = false
    } else {
      $deploy_files = true
    }
  }

  $clean_failed = $::vmwaretools::clean_failed_download ? {
    true    => '1',
    default => '0'
  }

  if ($::vmwaretools::archive_url == 'puppet') or ($::vmwaretools::archive_url =~ /^puppet:\/\//) {
    $download_vmwaretools = false
  } else {
    $download_vmwaretools = true
  }

  $awk_path = $::osfamily ? {
    'RedHat' => '/bin/awk',
    'Debian' => '/usr/bin/awk',
    default  => '/usr/bin/awk',
  }

  if $::vmwaretools::force_install == true {
    # The version 10 installer needs to use the -f (force) flag.
    if ( versioncmp(vmwaretools::version,'10.0') >= 0 ) {
      $install_command = "${vmwaretools::working_dir}/vmware-tools-distrib/vmware-install.pl -d -f"
    }
    else {
      $install_command = "echo 'yes' | ${::vmwaretools::working_dir}/vmware-tools-distrib/vmware-install.pl"
    }
  } else {
    $install_command = "${vmwaretools::working_dir}/vmware-tools-distrib/vmware-install.pl -d"
  }

  # Workaround for 'purge' bug on RH-based systems
  # https://projects.puppetlabs.com/issues/2833
  # https://projects.puppetlabs.com/issues/11450
  # https://tickets.puppetlabs.com/browse/PUP-1198
  $purge_package_ensure = $::osfamily ? {
    'RedHat' => absent,
    'Suse'   => absent,
    default  => purged,
  }

  if ($::osfamily == 'RedHat') and ($::lsbmajdistrelease == '5') {
    if 'PAE' in $::kernelrelease {
      $kernel_extension = regsubst($::kernelrelease, 'PAE$', '')
      $redhat_devel_package = "kernel-PAE-devel-${kernel_extension}"
    } elsif 'xen' in $::kernelrelease {
      $kernel_extension = regsubst($::kernelrelease, 'xen$', '')
      $redhat_devel_package = "kernel-xen-devel-${kernel_extension}"
    } else {
      $redhat_devel_package = "kernel-devel-${::kernelrelease}"
    }
  } else {
    $redhat_devel_package = "kernel-devel-${::kernelrelease}"
  }

  $purge_package_list = [ 'open-vm-dkms', 'vmware-tools-services',
                          'vmware-tools-foundation', 'open-vm-tools-desktop',
                          'open-vm-source', 'open-vm-toolbox', 'open-vm-tools',
                          'open-vm-tools-dbg', 'open-vm-tools-gui', 'vmware-kmp-debug',
                          'vmware-kmp-default', 'vmware-kmp-pae', 'vmware-kmp-trace',
                          'vmware-guest-kmp-debug', 'vmware-guest-kmp-default',
                          'vmware-guest-kmp-desktop', 'vmware-guest-kmp-pae',
                          'libvmtools-devel', 'libvmtools0' ]
}
