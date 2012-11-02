class vmwaretools::config {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
    ensure => file,
  }

  file {
    $vmwaretools::params::working_dir:
      ensure => directory;

    "${vmwaretools::params::working_dir}/version-check.sh":
      source => 'puppet:///modules/vmwaretools/version-check.sh',
      require => File[$vmwaretools::params::working_dir];
  }


}
