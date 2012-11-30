# == Class: vmwaretools::install
#
# Top-level vmwaretools installation class
#
# == Actions:
#
# Includes the package/exec installation submodules
#
# === Authors:
#
# Craig Watson <craig@cwatson.org>
#
# === Copyright:
#
# Copyright (C) 2012 Craig Watson
#
class vmwaretools::install {
  include vmwaretools::install::package
  include vmwaretools::install::exec
}
