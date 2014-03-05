CHANGELOG
=========

0.2.2
-----

2014-03-05

Bugfix release

  * vmwaretools::install      -- Packages will now be purged/installed all the time, not just when we install VMware Tools -- raised by [cdenneen](https://github.com/cdenneen) in [bug #27](https://github.com/craigwatson/puppet-vmwaretools/issues/27)
  * templates/download.sh.erb -- Added removal of the archive on an MD5 mismatch - raised by [herwigbogaert](https://github.com/herwigbogaert) in [bug #30](https://github.com/craigwatson/puppet-vmwaretools/issues/30)


0.2.1
-----

2013-10-31

Minor functionality improvement

  * esx_version -- Adding support for vSphere 5.5. Thanks to [Ryan McKern](https://github.com/mckern) for the pull request [GitHub Issue #18](https://github.com/craigwatson/puppet-vmwaretools/pull/22)!

0.2.0
-----

2013-09-11

Adding major functionality improvements

  * esx_version               -- New fact: reports the version of vSphere.
  * vmwaretools::timesync     -- New class: Handles management of time sychronisation with vSphere. Thanks to [Aaron Hicks](https://github.com/Aethylred) for the pull request [GitHub Issue #18](https://github.com/craigwatson/puppet-vmwaretools/pull/18)!
  * vmwaretools::config_tools -- Renamed class: was previously vmwaretools::kernel_upgrade
  * vmwaretools               -- New parameter: timesync. This paramter enables/disables the timesync feature of the VMware Tools.
                              -- Defaults to undef (literal), which will leave time synchronisation unmanaged.
                              -- Valid managed values are true to enable timesync and false to disable timesync, both literal booleans.

0.1.2
-----

2013-06-20

Bugfix release

  * vmwaretools::params -- Moving back to vmci.ko - see discussion on [GitHub Issue #14](https://github.com/craigwatson/puppet-vmwaretools/pull/14), huge thanks to [Ryan McKern](https://github.com/mckern) for the investigative work!

0.1.1
-----

2013-06-19

Bugfix release

  * Readme                      -- Adding Ubuntu 13.04 to Unsupported Operating Systems
  * vmwaretools                 -- Now fails when run on Ubuntu 13.04 (Raring)
  * vmwaretools::kernel_upgrade -- Moving creates attribute to /lib/modules/${::kernelrelease}/kernel/drivers/scsi/vmw_pvscsi.ko as suggested in [bug #12](https://github.com/craigwatson/puppet-vmwaretools/issues/12)

0.1.0
-----

2013-05-17

Adding major functionality improvements

  * vmwaretools_version fact      -- Added "not installed" output if VMware Tools isn't installed
  * vmwaretools::kernel_upgrade   -- New class: handles re-compiling VMware Tools following a kernel upgrade
  * vmwaretools::install::package -- Installing curl if download script is used.
                                  -- Adding open-vm-dkms to the list of purged packages
                                  -- Making the kernel-devel package installation explicitly use the running kernel - [pull request #8](https://github.com/craigwatson/puppet-vmwaretools/pull/8) by [mattiasgeniar](https://github.com/mattiasgeniar)
  * vmwaretools                   -- New parameter: prevent_downgrade, prevents downgrading if the version installed is newer than intended Puppet-deployed version (default: true)
  * templates/download.sh.erb     -- Using awk path from vmwaretools::params in script, and using curl rather than wget - [pull request #7](https://github.com/craigwatson/puppet-vmwaretools/pull/7) by [mattiasgeniar](https://github.com/mattiasgeniar)

0.0.5
-----

2013-05-07

Bugfix release

  vmwaretools::install::exec -- archive_location replaced by archive_url
  vmwaretools                -- Parameter Typo fixed

0.0.4
-----

2013-05-03

Including new README format and starting Changelogs.
