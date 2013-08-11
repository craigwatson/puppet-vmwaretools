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
# Copyright (C) 2013 Craig Watson
# Published under the GNU General Public License v3
#
#
class vmwaretools::install::archive {

  File {
    owner   => 'root',
    group   => 'root',
    require => File[$vmwaretools::working_dir],
  }

  if $vmwaretools::archive_url == 'puppet' {

    file { "${vmwaretools::working_dir}/VMwareTools-${vmwaretools::version}.tar.gz":
      ensure  => file,
      mode    => '0600',
      source  => "puppet:///modules/vmwaretools/VMwareTools-${vmwaretools::version}.tar.gz",
      notify  => Exec['uncompress_vmwaretools'],
    }

  } else {

    file { "${vmwaretools::working_dir}/download.sh":
      content => template('vmwaretools/download.sh.erb'),
      mode    => '0700',
      notify  => Exec['download_vmwaretools'],
    }

  }

}

