class vmwaretools::install::package {
  if ($::operatingsystem =~ /(?i)(centos|redhat|oraclelinux)/) {
    if (!defined(package['kernel-devel'])) {
      package { 'kernel-devel':
        ensure => installed,
      }
    }

    if (!defined(package['perl'])) {
      package { 'perl':
        ensure => installed,
      }
    }
  } elsif ($::operatingsystem == 'ubuntu') {
    if (!defined(package['linux-headers-server'])) {
      package { 'linux-headers-server':
        ensure => installed,
      }
    }

    if (!defined(package['build-essential'])) {
      package { 'build-essential':
        ensure => installed,
      }
    }
  }
}

class vmwaretools::install {

  include vmwaretools::install::package

  package { 'open-vm-tools':
    ensure => absent,
  }

  Exec {
    path    => ['/bin','/usr/bin'],
    timeout => 0,
    unless  => "${vmwaretools::params::working_dir}/version-check.sh \"${vmwaretools::params::version}\"",
  }

  file { "${vmwaretools::params::working_dir}/${vmwaretools::params::version}.tar.gz":
      mode    => '0600',
      owner   => 'root',
      group   => 'root',
      source  => "puppet:///modules/vmwaretools/VMwareTools-${vmwaretools::params::version}.tar.gz",
      require => File[$vmwaretools::params::working_dir];
  }

  exec {
    'clean_old_vmware_tools':
      command => "find ${vmwaretools::params::working_dir}/*.tar.gz -not -name ${vmwaretools::params::version}.tar.gz -delete",
      require => [ File[ "${vmwaretools::params::working_dir}/${vmwaretools::params::version}.tar.gz","${vmwaretools::params::working_dir}/version-check.sh"],
                   Class['vmwaretools::install::package']
                   ];

    'uncompress_vmware_tools':
      cwd     => $vmwaretools::params::working_dir,
      command => "tar -xf ${vmwaretools::params::working_dir}/${vmwaretools::params::version}.tar.gz",
      require => [ File[ "${vmwaretools::params::working_dir}/${vmwaretools::params::version}.tar.gz","${vmwaretools::params::working_dir}/version-check.sh"],
                   Class['vmwaretools::install::package'],
                   Exec['clean_old_vmware_tools'] ];

    'install_vmware_tools':
      command => "${vmwaretools::params::working_dir}/vmware-tools-distrib/vmware-install.pl -d",
      require => [ File[ "${vmwaretools::params::working_dir}/${vmwaretools::params::version}.tar.gz","${vmwaretools::params::working_dir}/version-check.sh"],
                   Class['vmwaretools::install::package'],
                   Exec['uncompress_vmware_tools'] ];

    'clean_up_vmware_tools_install':
      command => "rm -rf ${vmwaretools::params::working_dir}/vmware-tools-distrib",
      require => [ File[ "${vmwaretools::params::working_dir}/${vmwaretools::params::version}.tar.gz","${vmwaretools::params::working_dir}/version-check.sh"],
                   Class['vmwaretools::install::package'],
                   Exec['install_vmware_tools'] ];
  }

}
