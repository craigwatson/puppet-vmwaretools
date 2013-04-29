#puppet-vmwaretools

[![Build Status](https://secure.travis-ci.org/craigwatson/puppet-vmwaretools.png?branch=master)](http://travis-ci.org/craigwatson/puppet-vmwaretools)

####Table of Contents

1. [Overview - What is the puppet-vmwaretools module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with puppet-vmwaretools](#setup)
    * [What puppet-vmwaretools affects](#what-puppet-vmwaretools-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet-vmwaretools](#beginning-with-registry)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module manages the installation and upgrade of VMware Tools via the source code tarballs distributed with vSphere. The tarballs are transferred to the target by either HTTP download or Puppet filebucket (the default mechanism is the latter).

##Module Description

This module is designed to replace both the OSP packages provided by VMware's repositories and also the `open-vm-tools` package.

##Setup

###What puppet-vmwaretools affects

* Compares installed version with the configured version via the `vmwaretools` fact
* Transfer the VMware Tools archive to the target agent (via Puppet or HTTP)
* Untar the archive and run vmware-install-tools.pl
* Removes open-vm-tools

###Setup Requirements

* Pluginsync must be enabled, due to the vmwaretools custom fact distributed with this module.
	
###Beginning with puppet-vmwaretools	

To accept default class parameters:

    include vmwaretools

##Usage

The mechanism can be customised by declaring the module with `archive_url` and `archive_md5` parameters (default is to use Puppet filebuckets).

To specify a non-default version, working directory and HTTP URL (other variables can be viewed and/or modified in `manifests/init.pp`):

    class { 'vmwaretools':
      version     => '8.6.5-621624',
      working_dir => '/tmp/vmwaretools'
      archive_url => 'http://server.local/my/dir',
      archive_md5 => '9df56c317ecf466f954d91f6c5ce8a6f',
    }

##Reference

* Perl VMware Tools installer accepts all defaults

##Limitations

###Supported Operating Systems:

* Ubuntu (12.04 LTS tested)
* Red Hat family (RHEL 5 and 6 tested)
* Debian family (written but untested - reports appreciated)

##Development

* Copyright (C) 2013 Craig Watson - <craig@cwatson.org>
* VMware Tools fact by [janorn](https://github.com/janorn/puppet-vmwaretools)
* Distributed under the terms of the GNU General Public License v3 - see LICENSE file for details.
* Further contributions are extremely welcome - please submit a pull request on [GitHub](https://github.com/craigwatson/puppet-vmwaretools)

##Release Notes

* 0.0.4 - Including new README format.
