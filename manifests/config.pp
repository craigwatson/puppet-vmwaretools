class vmwaretools::config {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file {
    $vmwaretools::working_dir:
      ensure => directory;

    "${vmwaretools::working_dir}/version-check.sh":
      source => 'puppet:///modules/vmwaretools/version-check.sh',
      require => File[$vmwaretools::working_dir];
  }


}
