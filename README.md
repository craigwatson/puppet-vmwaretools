# puppet-vmwaretools

[![Build Status](https://secure.travis-ci.org/craigwatson/puppet-vmwaretools.png?branch=master)](http://travis-ci.org/craigwatson/puppet-vmwaretools)
[![Puppet Forge](http://img.shields.io/puppetforge/v/CraigWatson1987/vmwaretools.svg)](https://forge.puppetlabs.com/CraigWatson1987/vmwaretools)
[![Forge Endorsement](https://img.shields.io/puppetforge/e/CraigWatson1987/vmwaretools.svg)](https://forge.puppetlabs.com/CraigWatson1987/vmwaretools)
[![Forge Downloads](https://img.shields.io/puppetforge/dt/CraigWatson1987/vmwaretools.svg)](https://forge.puppetlabs.com/CraigWatson1987/vmwaretools)

## Table of Contents

1. [Overview - What is the puppet-vmwaretools module?](#overview)
1. [Module Description - What does the module do?](#module-description)
1. [Setup - The basics of getting started with puppet-vmwaretools](#setup)
    * [What puppet-vmwaretools affects](#what-puppet-vmwaretools-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet-vmwaretools](#beginning-with-registry)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the installation and upgrade of VMware Tools via the source code tarballs distributed by VMware.

## Module Description

This module is designed to replace both the OSP packages provided by VMware's repositories and also the `open-vm-tools` package. The module is O/S independent (tested on Ubuntu and Red Hat systems).

The tarballs are transferred to the target by either HTTP download or Puppet filebucket (the default mechanism), and then uncompressed and installed via the archive's Perl installation script.

Upgrading of currently installed VMware Tools packages is also supported - the module obtains the currently-installed VMware Tools version via a custom fact, and only deploys the tarball if a version mismatch occurs or if VMware Tools is not installed on the target system.

## Setup

### What puppet-vmwaretools affects

* Compares installed version with the configured version via the `vmwaretools` fact
* Transfer the VMware Tools archive to the target agent (via Puppet or HTTP)
* Untar the archive and run vmware-install-tools.pl (warning: this installer is run with the `-d` flag to accept all default answers).
* Removes several packages, see [params.pp](https://github.com/craigwatson/puppet-vmwaretools/blob/master/manifests/params.pp#L89) for the complete list.

### Setup Requirements

* Perl must be installed on the target systems in order to run the VMware Tools installer - installation of Perl is not handled by the module.
* Pluginsync must be enabled, due to the `vmwaretools_version` custom fact distributed with this module. If the module cannot access the fact, the Puppet run will fail.
* As of version 1.0.0, the module requires the [PuppetLabs stdlib module](https://github.come/puppetlabs/puppetlabs-stdlib) module to be available within your Puppet code.

### Beginning with puppet-vmwaretools

To accept default class parameters:

    include vmwaretools

## Usage

The source distribution mechanism can be customised by declaring the module with `archive_url` and `archive_md5` parameters (default is to use Puppet filebuckets).

To specify a non-default version, working directory and HTTP URL (other variables can be viewed and/or modified in `manifests/init.pp`):

    class { 'vmwaretools':
      version     => '8.6.5-621624',
      working_dir => '/tmp/vmwaretools',
      archive_url => 'http://server.local/my/dir',
      archive_md5 => '9df56c317ecf466f954d91f6c5ce8a6f',
    }

To stop `vmwaretools` from trying to install the development packages, Perl package, or curl package use the following paramters to disable their management with this module:

* `manage_dev_pkgs` set to false to prevent development packages being managed
* `manage_perl_pkgs` set to false to prevent Perl packages being managed
* `manage_curl_pkgs` set to false to prevent curl packages being managed

## Reference

### Facts

#### `vmwaretools_version`
  * Detects any existing VMware Tools installations and, if found, reports the installed version.

#### `esx_version`
  * Detects the underlying ESX version from `dmidecode`, thanks to [François Deppierraz](https://github.com/ctrlaltdel) for the [pull request](https://github.com/craigwatson/puppet-vmwaretools/pull/20)!

### Classes

#### `vmwaretools::install::exec`

  * Declares all `exec` commands run by the module.

#### `vmwaretools::install::package`

  * Handles installing the required tools to compile and install the archive, as well as purging OSP and open-source VMware Tools packages.
  * **NOTE:** Due to bugs in Puppet's `yum` provider, the OSP/open-source packages are only marked as `absent`, not `purged`.

#### `vmwaretools::install::archive`

  * Handles the archive distribution (either places a download script or the archive).

#### `vmwaretools::params`

  * O/S-specific and module configuration (e.g. paths to binaries and a boolean variable to control file deployment)

#### `vmwaretools::config_tools`

  * Executes `vmware-config-tools.pl -d` if the `vmci.ko` module doesn't exist for the running kernel

#### `vmwaretools::timesync`

  *  Handles time synchronisation between the virtual machine and host

## Limitations

### Supported Operating Systems

* Ubuntu/Debian
* CentOS/RedHat
* SuSE/SLES

### Unsupported Operating Systems

* Ubuntu 13.04 - see [VMware KB2050666](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2050666) and [bug #12](https://github.com/craigwatson/puppet-vmwaretools/issues/12)

## Development

* Copyright (C) 2013 to 2015 Craig Watson - <craig@cwatson.org>
* VMware Tools fact by [janorn](https://github.com/janorn/puppet-vmwaretools)
* Distributed under the terms of the Apache License v2.0 - see LICENSE file for details.
* **Please note** that the module was licensed under the terms of the GNU General Public License v3 until commit [fea91b58241481fc3fc4aa0e02996cc9ef0f131e](https://github.com/craigwatson/puppet-vmwaretools/commit/fea91b58241481fc3fc4aa0e02996cc9ef0f131e)
* Further contributions and testing reports are extremely welcome - please submit a pull request or issue on [GitHub](https://github.com/craigwatson/puppet-vmwaretools)
* Testing environment kindly donated by [Sleek Networks Ltd (An Adapt Company)](http://www.sleek.net)
