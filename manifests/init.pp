# == Class: vmwaretools
#
# This class handles installing the VMware Tools via the archives distributed
# by VMware. Upgrades and downgrades are also supported.
#
# The archive can either be placed on an HTTP-accessible location, or within
# this module's 'files' directory.
#
# === Parameters:
#
# [*version*]
#   The numeric version of the tools that you want to install. This can be
#   found by looking at the filename of the archive - e.g. 8.6.5-621624
#
# [*working_dir*]
#   The directory to store files in.
#   Default: '/tmp/vmwaretools' (string)
#
# [*redhat_install_devel*]
#   If you really want to install kernel headers on RedHat-derivative operating
#   systems - you will likely not need this as most RH distros have
#   pre-compiled kernel modules.
#   Default: false (boolean)
#
# [*archive_url*]
#   Specify an HTTP location to download the archive from - this is useful when
#   you want to avoid packaging the installer with your Puppet code.  NOTE that
#   this does NOT include the filename, just the path to the file. The filename
#   will be constucted as 'VMwareTools-$version.tar.gz'.
#   Default: 'puppet' (string)
#
# [*archive_md5*]
#   md5sum of the archive - required if using an HTTP location above.
#   Default: '' (empty string)
#
# [*fail_on_non_vmware*]
#   Output a hard failure message if the module is run on non-vmware hardware.
#   Default: false (boolean)
#
# [*keep_working_dir*]
#   Keep the working dir on disk after installation.
#   Default: false (boolean)
#
# [*prevent_downgrade*]
#   If the system has a version of the tools installed which is newer that what
#   is set in the version parameter, do not downgrade the tools.
#   Default: true (boolean)
#
# [*prevent_upgrade*]
#   If the system has a version of the tools installed which is older that what
#   is set in the version parameter, do not upgrade the tools.
#   Note: This will still allow tools to be downgraded unless prevent_downgrade
#   also is set.
#   Default: false (boolean)
#
# [*timesync*]
#   Should the node synchronise their system clock with the vSphere server?
#   Acceptable values are true, false (both literal booleans, NOT quoted
#   strings) or undef (literal). Booleans will either enable or disable
#   synchronisation, and undef will disable management of timesync altogether.
#   Default: undef (UNDEFINED)
#
# == Actions:
#
# * Compares installed version with the configured version
# * Transfer the VMware Tools archive to the target agent (via Puppet or HTTP)
# * Untar the archive, run vmware-install-tools.pl
# * Removes open-vm-tools
#
# === Requires:
#
# * HTTP download script: wget, awk, md5sum
#
# === Sample Usage:
#
# To accept defaults:
#
#   include vmwaretools
#
# To specify a non-default version, working directory and HTTP URL:
#
#   class { 'vmwaretools':
#     version     => '8.6.5-621624',
#     working_dir => '/tmp/vmwaretools'
#     archive_url => 'http://server.local/my/dir',
#     archive_md5 => '9df56c317ecf466f954d91f6c5ce8a6f',
#   }
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
class vmwaretools (
  $version              = '9.0.0-782409',
  $working_dir          = '/tmp/vmwaretools',
  $redhat_install_devel = false,
  $archive_url          = 'puppet',
  $archive_md5          = '',
  $fail_on_non_vmware   = false,
  $keep_working_dir     = false,
  $prevent_downgrade    = true,
  $prevent_upgrade      = false,
  $timesync             = undef,
  $manage_dev_pkgs      = true,
  $manage_perl_pkgs     = true,
  $manage_curl_pkgs     = true
) {

  # Validate parameters where appropriate
  validate_string($version)
  validate_absolute_path($working_dir)
  validate_bool($redhat_install_devel, $manage_dev_pkgs)
  validate_string($archive_url)
  validate_string($archive_md5)
  validate_bool($fail_on_non_vmware)
  validate_bool($keep_working_dir)
  validate_bool($prevent_downgrade)
  validate_bool($prevent_upgrade)

  # Puppet Lint gotcha -- facts are returned as strings, so we should ignore
  # the quoted-boolean warning here. Related links below:
  # https://tickets.puppetlabs.com/browse/FACT-151
  # https://projects.puppetlabs.com/issues/3704

  if str2bool($::is_virtual) and $::virtual == 'vmware' and $::kernel == 'Linux' {

    if $::vmwaretools_version == undef {
      fail 'vmwaretools_version fact not present, please check your pluginsync configuraton.'
    }

    if (($archive_url == 'puppet') or ($archive_url =~ /^puppet:\/\//)) {
      $download_vmwaretools = false
    } else {
      $download_vmwaretools = true
    }

    if (($download_vmwaretools == true) and ($archive_md5 == '')) {
      fail 'MD5 not given for VMware Tools installer package'
    }

    if $::lsbdistcodename == 'raring' {
      fail 'Ubuntu 13.04 is not supported by this module'
    }

    include vmwaretools::params
    include vmwaretools::install
    include vmwaretools::config
    include vmwaretools::config_tools

    if $timesync != undef {
      include vmwaretools::timesync
    }
  } elsif $fail_on_non_vmware == true and (str2bool($::is_virtual) == false or $::virtual != 'vmware') {
    fail 'Not a VMware platform.'
  }
}
