class vmwaretools::timesync (
  $ensure  = 'enabled'
){

  $cmd = "${vmwaretools::params::toolbox_path}/${vmwaretools::params::toolbox_cmd}"


  case $ensure {
    'disable', 'absent':  {
      exec{"${cmd} timesync disable":
        onlyif => "${cmd} timesync status | grep Enabled",
      }
    }
    default:              {
      exec{"${cmd} timesync enable":
        onlyif => "${cmd} timesync status | grep Disabled",
      }
    }
  }

}