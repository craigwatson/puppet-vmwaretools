# == Class: vmwaretools::timesync
#
# This class handles synchronising the node's clock with vSphere
#
# == Actions:
#
# Either enables or disables timesync
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
class vmwaretools::timesync {

  case $vmwaretools::timesync {
    true: {
      $cmd_action = 'enable'
      $cmd_grep   = 'Disabled'
    }

    false: {
      $cmd_action = 'disable'
      $cmd_grep   = 'Enabled'
    }

    default: {
      fail "Unsupported value ${vmwaretools::timesync} for vmwaretools::timesync."
    }
  }

  exec { "vmwaretools_timesync_${cmd_action}":
    command => "/usr/bin/vmware-toolbox-cmd timesync ${cmd_action}",
    onlyif  => "/usr/bin/vmware-toolbox-cmd timesync status | grep ${cmd_grep}",
  }

}
