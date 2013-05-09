# == Class: vmwaretools::params
#
# This class handles parameters for the vmwaretools module
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
# Copyright (C) 2013 Craig Watson
# Published under the GNU General Public License v3
#
class vmwaretools::params {

  if $vmwaretools::prevent_downgrade {
    if versioncmp($::vmwaretools_version,$vmwaretools::version) > 0 {
      $deploy_files = false
    } else {
      $deploy_files = true
    }
  } else {
    $deploy_files = $::vmwaretools_version ? {
      $vmwaretools::version => false,
      default               => true,
    }
  }

  $awk_path = $::osfamily ? {
    'RedHat' => '/bin/awk',
    'Debian' => '/usr/bin/awk',
    default  => '/usr/bin/awk',
  }

}
