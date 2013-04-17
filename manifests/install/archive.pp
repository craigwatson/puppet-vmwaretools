# == Class: vmwaretools::install::archive
#
# This class handles the VMware Tools compilation and uncompressing.
#
# == Actions:
#
# Either places the tarball via Puppet or downloads via wget
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
#
class vmwaretools::install::archive {


  file { "${vmwaretools::working_dir}/${vmwaretools::version}.tar.gz":
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    notify  => Exec['uncompress_vmware_tools'],
    source  => "puppet:///modules/vmwaretools/VMwareTools-${vmwaretools::version}.tar.gz",
    require => File[$vmwaretools::working_dir],
  }

  if $vmwaretools::installer_location == 'puppet' {
    File["${vmwaretools::working_dir}/${vmwaretools::version}.tar.gz"] {
      source  => "puppet:///modules/vmwaretools/VMwareTools-${vmwaretools::version}.tar.gz",
    }
  } else {
    file {
      "${vmwaretools::working_dir}/download.sh":
        content => template('vmwaretools/download.sh.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
        require => File[$vmwaretools::working_dir];
    }
  }
}

