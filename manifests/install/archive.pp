# == Class: vmwaretools::install::archive
#
# This class handles the placing the archive.
#
# == Actions:
#
# * Either via:
#   - HTTP, with an md5 checksum comparison
#   - Puppet filebucket
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
class vmwaretools::install::archive {

  file { "${vmwaretools::working_dir}/VMwareTools-${vmwaretools::version}.tar.gz":
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    require => File[$vmwaretools::working_dir],
  }

  if $vmwaretools::archive_url == 'puppet' {

    File["${vmwaretools::working_dir}/VMwareTools-${vmwaretools::version}.tar.gz"] {
      ensure  => file,
      source  => "puppet:///modules/vmwaretools/VMwareTools-${vmwaretools::version}.tar.gz",
      notify  => Exec['uncompress_vmwaretools'],
    }

  } elsif ( 'puppet://' in $vmwaretools::archive_url ) {

    File["${vmwaretools::working_dir}/VMwareTools-${vmwaretools::version}.tar.gz"] {
      ensure  => file,
      source  => "${vmwaretools::archive_url}/VMwareTools-${vmwaretools::version}.tar.gz",
      notify  => Exec['uncompress_vmwaretools'],
    }

  } else {
    file { "${vmwaretools::working_dir}/download.sh":
      content => template('vmwaretools/download.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      notify  => Exec['download_vmwaretools'],
      require => File[$vmwaretools::working_dir];
    }

  }

}

