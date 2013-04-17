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
#   Default: /opt/vmware (string)
#
# [*redhat_install_devel*]
#   If you really want to install kernel headers on RedHat-derivative operating
#   systems - you will likely not need this as most RH distros have
#   pre-compiled kernel modules.
#   Default: false (boolean)
#
# [*clobber_modules*]
#   Whether to overwrite modules compiled by other packages (including default
#   kernel modules.
#   Default: false (boolean)
#
# [*installer_location*]
#   Specify an HTTP location to download the install tarball from - this is
#   useful when you want to avoid packaging the installer with your Puppet code.
#   Default: 'puppet' (string)
#
# [*installer_md5*]
#   MD5sum of your installer package - required if using an HTTP location above.
#   Default: 'unset' (string)
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
# To accept defaults:
#
#   include vmwaretools
#
# To specify a version and working directory
#
#   class { 'vmwaretools':
#     version     => '8.6.5-621624',
#     working_dir => '/opt/vmware'
#   }
#
# To specify a download location:
#
#   class { 'vmwaretools':
#     version            => '9.0.0-782409',
#     installer_location => 'http://server.local/VMwareTools-9.0.0-782409.tar.gz',
#     installer_md5      => '9df56c317ecf466f954d91f6c5ce8a6f',
#   }
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
class vmwaretools (
  $version              = '9.0.0-782409',
  $working_dir          = '/opt/vmware',
  $redhat_install_devel = false,
  $clobber_modules      = false,
  $installer_location   = 'puppet',
  $installer_md5        = 'unset',
) {

  if $installer_location != 'puppet' and $installer_md5 == 'unset' {
    fail 'MD5 not given for VMware Tools installer package'
  }

  if $::virtual == 'vmware' {
    include vmwaretools::install
    include vmwaretools::config
  } else {
    fail 'Not a VMware platform.'
  }

}
