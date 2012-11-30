# == Class: vmwaretools::config
#
# This class handles the VMware Tools compilation and uncompressing.
#
# == Actions:
#
# Uncompresses the VMware Tools tarball
# Installs VMware Tools, accepting all installer defaults
# Cleans up old tarballs
# Cleans up VMware Tools uncompressed files
#
# === Authors:
#
# Craig Watson <craig@cwatson.org>
#
# === Copyright:
#
# Copyright (C) 2012 Craig Watson
#

class vmwaretools::install::exec {
  Exec {
    path    => ['/bin','/usr/bin'],
    timeout => 0,
    unless  => "${vmwaretools::working_dir}/version-check.sh \"${vmwaretools::version}\"",
  }

  file { "${vmwaretools::working_dir}/${vmwaretools::version}.tar.gz":
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/vmwaretools/VMwareTools-${vmwaretools::version}.tar.gz",
    require => File[$vmwaretools::working_dir];
  }

  exec {
    'clean_old_vmware_tools':
      command => "find ${vmwaretools::working_dir}/*.tar.gz -not -name ${vmwaretools::version}.tar.gz -delete",
      require => [
        File[ "${vmwaretools::working_dir}/${vmwaretools::version}.tar.gz","${vmwaretools::working_dir}/version-check.sh"],
        Class['vmwaretools::install::package']
      ];

    'uncompress_vmware_tools':
      cwd     => $vmwaretools::working_dir,
      command => "tar -xf ${vmwaretools::working_dir}/${vmwaretools::version}.tar.gz",
      require => [
        File[ "${vmwaretools::working_dir}/${vmwaretools::version}.tar.gz","${vmwaretools::working_dir}/version-check.sh"],
        Class['vmwaretools::install::package'],
        Exec['clean_old_vmware_tools']
      ];

    'install_vmware_tools':
      command => "${vmwaretools::working_dir}/vmware-tools-distrib/vmware-install.pl -d",
      require => [
        File[ "${vmwaretools::working_dir}/${vmwaretools::version}.tar.gz","${vmwaretools::working_dir}/version-check.sh"],
        Class['vmwaretools::install::package'],
        Exec['uncompress_vmware_tools']
      ];

    'clean_up_vmware_tools_install':
      command => "rm -rf ${vmwaretools::working_dir}/vmware-tools-distrib",
      require => [
        File[ "${vmwaretools::working_dir}/${vmwaretools::version}.tar.gz","${vmwaretools::working_dir}/version-check.sh"],
        Class['vmwaretools::install::package'],
        Exec['install_vmware_tools']
      ];
  }
}
