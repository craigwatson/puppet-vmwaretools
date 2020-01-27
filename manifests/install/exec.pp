# == Class: vmwaretools::install::exec
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
# Copyright (C) Craig Watson
# Published under the Apache License v2.0
#
class vmwaretools::install::exec {

  Exec {
    path        => ['/bin','/usr/bin', '/sbin'],
    refreshonly => true,
    timeout     => 0,
  }

  if $::vmwaretools::params::download_vmwaretools == true {

    if $::vmwaretools::manage_curl_pkgs == true {
      $download_require = [Package['curl'],File["${::vmwaretools::working_dir}/download.sh"]]
    } else {
      $download_require = File["${::vmwaretools::working_dir}/download.sh"]
    }

    exec { 'download_vmwaretools':
      command     => "${::vmwaretools::working_dir}/download.sh",
      creates     => "${::vmwaretools::working_dir}/VMwareTools-${::vmwaretools::version}.tar.gz",
      require     => $download_require,
      refreshonly => false,
      notify      => Exec['uncompress_vmwaretools'],
    }

    Exec['uncompress_vmwaretools'] {
      require => Exec['download_vmwaretools'],
    }

  } else {
    Exec['uncompress_vmwaretools'] {
      require => File["${::vmwaretools::working_dir}/VMwareTools-${::vmwaretools::version}.tar.gz"],
    }
  }

  exec {
    'uncompress_vmwaretools':
      cwd     => $::vmwaretools::working_dir,
      command => "tar -xf ${::vmwaretools::working_dir}/VMwareTools-${::vmwaretools::version}.tar.gz",
      notify  => Exec['install_vmwaretools'];
    'install_vmwaretools':
      command => $::vmwaretools::params::install_command,
      require => Exec['uncompress_vmwaretools'],
      notify  => Exec['clean_vmwaretools'];
    'clean_vmwaretools':
      # lint:ignore:140chars
      command => "rm -rf ${::vmwaretools::working_dir}/vmware-tools-distrib && find ${::vmwaretools::working_dir}/*.tar.gz -not -name VMwareTools-${::vmwaretools::version}.tar.gz -delete",
      # lint:endignore
      require => Exec['install_vmwaretools'];
  }

  if $::vmwaretools::keep_working_dir == false {
    Exec['clean_vmwaretools'] {
      notify => Exec['remove_vmwaretools_working_dir'],
    }

    exec { 'remove_vmwaretools_working_dir':
      command => "rm -rf ${::vmwaretools::working_dir}",
      require => Exec['clean_vmwaretools'],
    }
  }
}
