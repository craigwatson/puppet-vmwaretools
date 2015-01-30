# == Class: vmwaretools::install
#
# Top-level vmwaretools installation class
#
# == Actions:
#
# Includes the archive/package/exec installation submodules
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
class vmwaretools::install {

  include vmwaretools::install::package

  if $vmwaretools::params::deploy_files == true {
    include vmwaretools::install::archive
    include vmwaretools::install::exec

    Class['vmwaretools::install::package'] ->
    Class['vmwaretools::install::archive'] ->
    Class['vmwaretools::install::exec']
  }
}
