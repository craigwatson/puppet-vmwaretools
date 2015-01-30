# Change Log

## 1.3.0

### 2015-01-30 - Feature Improvement

### Class: `vmwaretools`
  * Added parameters to manage the installation of certain supporting packages - thanks to [Aaron Hicks](https://github.com/Aethylred) for Pull Request [#60](https://github.com/craigwatson/puppet-vmwaretools/pull/60)

### Class: `vmwaretools::install::package`
  * Adjusted class to use above parameters

## 1.2.0

### 2014-12-09 - Feature Improvement

#### Class: `vmwaretools`
  * Added `prevent_upgrade` parameter to does not deploy files if the Puppet version is higher than the installed version)
  * Modified the regex for how to download vmwaretools to fix a Lint issue with the previous syntax
  * Huge thanks to [esalberg](https://github.com/esalberg) for Pull Request [#58](https://github.com/craigwatson/puppet-vmwaretools/pull/58)!

## 1.1.0

### 2014-10-02 - Feature Improvement

#### Class: `vmwaretools::params`
  * Added `vmware-tools-foundation` to purge_package_list to fully remove OSP tools - thanks to [Christian Groschupp](https://github.com/cgroschupp)
  * Added `purge_list_ensure` variable to work around bug in Puppet's yum provider, see these bugs: [1](https://projects.puppetlabs.com/issues/2833), [2](https://projects.puppetlabs.com/issues/11450), [3](https://tickets.puppetlabs.com/browse/PUP-1198) - thanks to [Justin T.](https://github.com/thesysadm) for PR [#53](https://github.com/craigwatson/puppet-vmwaretools/pull/53)

#### Class: `vmwaretools::install::package`
  * Implemented `purge_list_ensure` as per above bug-fix

#### Template: `download.sh.erb`
  * Redirect error output to standard error, and exit early if the download fails - thanks to [Christian Groschupp](https://github.com/cgroschupp)

#### Change Log
  * Major overhaul and Markdown prettification!

#### Readme
  * Minor Markdown formatting changes

## 1.0.1

### 2014-10-01 - Bugfix Release

#### Class: `vmwaretools`
  * Fixed regression bug [#51](https://github.com/craigwatson/puppet-vmwaretools/issues/51) caused by facts being returned as strings, using stdlib's str2bool function - thanks [Justin T.](https://github.com/thesysadm)!

## 1.0.0

### 2014-09-24 - Major Release

#### Module-wide changes
  * This and all future versions of the module are now distributed under the **Apache Licence v2.0**! Previous versions are still licensed under the GNU General Public Licence v3.
  * This module is now dependant on [PuppetLabs' stdlib module](https://github.come/puppetlabs/puppetlabs-stdlib). Please make sure this module is available within your Puppet codebase.

#### Fact: `vmwaretools`
  * Fixes `vmwaretools` fact detection for failed tools installs - thanks [Markus Frosch](https://github.com/lazyfrosch) for [pull request #49](https://github.com/craigwatson/puppet-vmwaretools/pull/49)!

#### Class: `vmwaretools`
  * `open-vm-tools` is now `purged` rather than just `absent` - thanks [Markus Frosch](https://github.com/lazyfrosch) for [pull request #49](https://github.com/craigwatson/puppet-vmwaretools/pull/49)!

## 0.4.3

### 2014-09-08 - Bugfix Release

#### Class: `vmwaretools`
  * We now only parse the module on Linux kernels, fixes [ticket #47](https://github.com/craigwatson/puppet-vmwaretools/pull/47), thanks to [thesysadm](https://github.com/thesysadm)!

## 0.4.2

### 2014-08-06 - Bugfix Release

#### Class: `vmwaretools::params`
  * Adding new parameter for RH 5.x PAE/xen kernels for kernel-devel package (thanks Mark Stunnenberg!)
  * Adding new parameter for the list of packages to purge

#### Class: `vmwaretools::install::package`
  * Only installing `build-essential` on Debian - [pull request #43](https://github.com/craigwatson/puppet-vmwaretools/pull/43)
  * Changing RedHat `kernel-devel` package name to account for PAE/xen kernels on RH 5.x (thanks Mark Stunnenberg!)
  * Adding `open-vm-tools-desktop` to list of packages to purge

## 0.4.1

### 2014-06-20 - Bugfix Release

#### Class: `vmwaretools`
  * Removing `config_creates` override
  * Documentation syntax correction - [pull request #42](https://github.com/craigwatson/puppet-vmwaretools/pull/42)
  * Added check fof the `vmwaretools_version` fact - the module will hard-fail if this cannot be found

#### Class: `vmwaretools::params`
  * Remvoing `config_creates` references

#### Class: `vmwaretools::config_tools`
  * Replacing `creates` paramter with a more straightforward `unless` check using lsmod to check for the vmci kernel module that should be installed when vmware-config-tools.pl runs

## 0.4.0

### 2014-05-16 - Functionality Improvement

#### Class: `vmwaretools`
  * Improving support for downloading VMware Tools via external Puppet modules (thanks to [Sam Keeley](https://github.com/keeleysam) and [Aedu](https://github.com/Aedu) for Pull Requests [#36](https://github.com/craigwatson/puppet-vmwaretools/pull/36) and [#37](https://github.com/craigwatson/puppet-vmwaretools/pull/37) respectively)

#### Class: `vmwaretools::params`
  * Adding Ubuntu 10.04 LTC (Lucid Lynx) override for `config_creates_real` variable

## 0.3.1

### 2014-04-14 - Bugfix Release

#### Class: `vmwaretools::params`
  * Correcting typo in config_creates assignment

## 0.3.0

### 2014-04-14 - Functionality Improvement

#### Class: `vmwaretools` main
  * Adding `config_creates` parameter to main class declaration

#### Class: `vmwaretools::params`
  * Renaming `config_creates` to `config_creates_real`
  * Adding case statement for Ubuntu/Debian within the Debian osfamily case

#### Class: `vmwaretools::config_tools`
  * Using vmwaretools::params::config_creates_real instead of vmwaretools::params::config_creates

## 0.2.5

### 2014-04-10 - Bugfix Release

#### Class: `vmwaretools`
  * Facter facts are strings, not literal booleans!

## 0.2.4

### 2014-04-09 - Bugfix Release

#### Class: `vmwaretools`
  * Fixing logic in init.pp to silently fail if the module is included on non-VMware hardware and the $fail_on_non_vmware parameter is not set to true (bug reported by Marcus Johansson by email - thanks!)

## 0.2.3

### 2014-04-07 - Bugfix Release

#### Class: `vmwaretools::install::package`
  * We now remove the vmware-tools-services package as well as open-vm-tools - [pull request #34](https://github.com/craigwatson/puppet-vmwaretools/pull/34) and packages are now purged rather than removed

#### Class: `vmwaretools::params`
  * `config_creates` is now different across Debian and RedHat osfamilys - [pull request #34](https://github.com/craigwatson/puppet-vmwaretools/pull/34)

## 0.2.2

### 2014-03-05 - Bugfix Release

#### Class: `vmwaretools::install`
  * Packages will now be purged/installed all the time, not just when we install VMware Tools -- raised by [cdenneen](https://github.com/cdenneen) in [bug #27](https://github.com/craigwatson/puppet-vmwaretools/issues/27)

#### Template: `download.sh.erb`
  * Added removal of the archive on an MD5 mismatch - raised by [herwigbogaert](https://github.com/herwigbogaert) in [bug #30](https://github.com/craigwatson/puppet-vmwaretools/issues/30)

## 0.2.1

### 2013-10-31 - Functionality Improvement (non-SemVer increment)

#### Fact: `esx_version`
  * Adding support for vSphere 5.5. Thanks to [Ryan McKern](https://github.com/mckern) for the pull request [GitHub Issue #18](https://github.com/craigwatson/puppet-vmwaretools/pull/22)!

## 0.2.0

### 2013-09-11 - Functionality Improvements

#### Fact: `esx_version`
  * New fact: reports the version of vSphere.

#### Class: `vmwaretools::timesync`
  * New class: Handles management of time sychronisation with vSphere. Thanks to [Aaron Hicks](https://github.com/Aethylred) for the pull request [GitHub Issue #18](https://github.com/craigwatson/puppet-vmwaretools/pull/18)!

#### Class: `vmwaretools::config_tools`
  * Renamed class: was previously `vmwaretools::kernel_upgrade`

#### Class: `vmwaretools`
  * New parameter: timesync. This paramter enables/disables the timesync feature of the VMware Tools.
  * Defaults to undef (literal), which will leave time synchronisation unmanaged.
  * Valid managed values are true to enable timesync and false to disable timesync, both literal booleans.

## 0.1.2

### 2013-06-20 - Bugfix Release

#### Class: `vmwaretools::params`
  * Moving back to `vmci.ko` - see discussion on [GitHub Issue #14](https://github.com/craigwatson/puppet-vmwaretools/pull/14), huge thanks to [Ryan McKern](https://github.com/mckern) for the investigative work!

## 0.1.1

### 2013-06-19 - Bugfix Release

#### Readme
  * Adding Ubuntu 13.04 to Unsupported Operating Systems

#### Class: `vmwaretools`
  * Now fails when run on Ubuntu 13.04 (Raring)

#### Class: `vmwaretools::kernel_upgrade`
  * Moving `creates` attribute to `/lib/modules/${::kernelrelease}/kernel/drivers/scsi/vmw_pvscsi.ko` as suggested in [bug #12](https://github.com/craigwatson/puppet-vmwaretools/issues/12)

## 0.1.0

### 2013-05-17 - Functionality Improvements

#### Fact: `vmwaretools_version`
  * Added "not installed" output if VMware Tools isn't installed

#### Class: `vmwaretools::kernel_upgrade`
  * New class: handles re-compiling VMware Tools following a kernel upgrade

#### Class: `vmwaretools::install::package`
  * Installing `curl` if download script is used.
  * Adding `open-vm-dkms` to the list of purged packages
  * Making the `kernel-devel` package installation explicitly use the running kernel - [pull request #8](https://github.com/craigwatson/puppet-vmwaretools/pull/8) by [mattiasgeniar](https://github.com/mattiasgeniar)

#### Class: `vmwaretools`
  * New parameter: `prevent_downgrade`, prevents downgrading if the version installed is newer than intended Puppet-deployed version (default: `true`)

#### Template: `download.sh.erb`
  * Using `awk` path from `vmwaretools::params` in script, and using `curl` rather than `wget` - [pull request #7](https://github.com/craigwatson/puppet-vmwaretools/pull/7) by [mattiasgeniar](https://github.com/mattiasgeniar)

## 0.0.5

### 2013-05-07 - Bugfix Release

#### Class: `vmwaretools::install::exec`
  * `archive_location` replaced by `archive_url`

#### Class: `vmwaretools`
  * Parameter Typo fixed

##0.0.4

### 2013-05-03
  * Including new README format and starting Changelogs.
