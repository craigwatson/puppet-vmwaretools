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
# [*install_devel*]
#   If you really want to install kernel headers on RedHat- or Suse-derivative
#   operating systems - you will likely not need this as most RH distros have
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
# [*ignore_autodetect*]
#   Ignores the automatic platform detection, and forces the module to be
#   loaded, regardless of the underlying system. Only really useful for testing
#   as it could have unpredictable results.
#   Default: false (boolean)
#
# [*force_install*]
#   Forces installation by piping 'yes' to the VMware Tools install script.
#   This is necessary to install on operating systems where VMware has opted
#   to favour the open-vm-tools pacakge. NOTE: The tools will still fail to
#   install on these operating systems, so it is recommended to set this
#   parameter to true.
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
# [*manage_dev_pkgs*]
#   Whether to install kernel devel packages which are used for compiling VMware
#   Tools on operating systems without pre-built binaries.
#   Default: true (boolean)
#
# [*manage_perl_pkgs*]
#   Whether to install perl, which is used to run the installer. Useful when
#   other modules are managing the package, although we use stdlib's
#   ensure_package resource which should eliminate most issues.
#   NOTE that the installer will fail without perl present on the sytem.
#   Default: true (boolean)
#
# [*manage_curl_pkgs*]
#   Whether to install curl, which is used to download the VMware Tools from an
#   HTTP location. Useful when other modules are managing the package, although
#   we use stdlib's ensure_package resource which should eliminate most issues.
#   Default: true (boolean)
#
# [*clean_failed_download*]
#   Whether to remove failed HTTP downloads. This ensures that broken downloads
#   are automatically retried on the next Puppet run.
#   NOTE: This will default to true in a later release of this module.
#   Default: false (boolean)
#
# [*curl_proxy*]
#   Specify an HTTP proxy to be used with curl when downloading the archive.
#   This can be of the format http://<hostname>:<port>
#   Default: false (no proxy usage)
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
class vmwaretools (
  $version               = '9.0.0-782409',
  $working_dir           = '/tmp/vmwaretools',
  $install_devel         = false,
  $archive_url           = 'puppet',
  $archive_md5           = '',
  $fail_on_non_vmware    = false,
  $keep_working_dir      = false,
  $ignore_autodetect     = false,
  $force_install         = false,
  $prevent_downgrade     = true,
  $prevent_upgrade       = false,
  $timesync              = undef,
  $manage_dev_pkgs       = true,
  $manage_perl_pkgs      = true,
  $manage_curl_pkgs      = true,
  $curl_proxy            = false,
  $clean_failed_download = false,
) {

  # Validate parameters where appropriate
  validate_string($version)
  validate_absolute_path($working_dir)
  validate_string($archive_url)
  validate_string($archive_md5)
  validate_bool($ignore_autodetect)
  validate_bool($install_devel)
  validate_bool($manage_dev_pkgs)
  validate_bool($fail_on_non_vmware)
  validate_bool($keep_working_dir)
  validate_bool($prevent_downgrade)
  validate_bool($prevent_upgrade)
  validate_bool($clean_failed_download)

  # Puppet Lint gotcha -- facts are returned as strings, so we should ignore
  # the quoted-boolean warning here. Related links below:
  # https://tickets.puppetlabs.com/browse/FACT-151
  # https://projects.puppetlabs.com/issues/3704

  if ($ignore_autodetect == true) or ((str2bool("${::is_virtual}")) and ($::virtual == 'vmware') and ($::kernel == 'Linux')) {

    if ($::vmwaretools_version == undef) {
      fail 'vmwaretools_version fact not present, please check your pluginsync configuraton.'
    }

    if ($::lsbdistcodename == 'raring') {
      fail 'Ubuntu 13.04 is not supported by this module'
    }

    include ::vmwaretools::params

    if (($::vmwaretools::params::download_vmwaretools == true) and ($archive_md5 == '')) {
      fail 'MD5 not given for VMware Tools installer package'
    }

    include ::vmwaretools::install
    include ::vmwaretools::config_tools

    if ($timesync != undef) {
      include ::vmwaretools::timesync
    }
  } elsif ($fail_on_non_vmware == true) and ((str2bool($::is_virtual) == false) or ($::virtual != 'vmware')) {
    fail 'Not a VMware platform.'
  }
}
