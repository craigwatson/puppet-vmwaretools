class vmware::install::package {

  package { 'open-vm-tools':
    ensure => purged,
  }

  if (!defined(package['perl'])) {
    package { 'perl':
      ensure => installed,
    }
  }

  case $::osfamily {

    'Debian' : {
       package { ['linux-headers-server','build-essential'] :
        ensure => present,
      }
    }

    'RedHat' : {
      if $vmwaretools::redhat_install_devel == true {
        package { 'kernel-devel':
          ensure => present,
        }  
      }
    }

    default : { fail "${::osfamily} not supported yet." }
  }

}