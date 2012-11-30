# == Class: vmwaretools
#
# This class handles installing the VMware Tools via the tarballs distributed
# by VMware. Add your tarball to the files directory before proceeding.
#
# === Parameters:
#
# [*version*]
#   The numeric version of the tools that you want to install. This can be
#   found by looking at the filename of the tarball - e.g. 8.6.5-621624
#
# [*working_dir*]
#   The directory to store files in.
#   Default: /opt/vmware
#
# [*redhat_install_devel*]
#   If you really want to install kernel headers on RedHat-derivative operating
#   systems - you will likely not need this as most RH distros have
#   pre-compiled kernel modules.
#   Default: false
#
# == Actions:
#
# Compares installed version with the configured version
# Transfer the VMware Tools tarball to the target agent
# Untar the archive and run vmware-install-tools.pl
# Removes open-vm-tools
#
# === Requires:
#
# Nothing
#
# === Sample Usage:
#
#   class { 'vmwaretools':
#     version     = '8.6.5-621624',
#     working_dir = '/opt/vmware'
#   }
#
# Or to accept defaults:
#
#   include vmwaretools
#
# === Authors:
#
# Craig Watson <craig@cwatson.org>
#
# === Copyright:
#
# Copyright (C) 2012 Craig Watson
#
class vmwaretools (
  $version              = '8.6.5-621624',
  $working_dir          = '/opt/vmware',
  $redhat_install_devel = false,
  $clobber_modules      = false,
) {

  # Only proceed if we're on a VMware platform
  if $::virtual == 'vmware' {
    include vmwaretools::install
    include vmwaretools::config
  } else {
    fail 'Not a VMware platform.'
  }

}
