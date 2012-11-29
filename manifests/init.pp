class vmwaretools (
  $version              = '8.6.5-621624',
  $working_dir          = '/opt/vmware',
  $redhat_install_devel = false,
) {

  include vmwaretools::install
  include vmwaretools::config

}
