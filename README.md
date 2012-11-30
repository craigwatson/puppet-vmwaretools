puppet-vmwaretools
==================

[![Build Status](https://secure.travis-ci.org/craigwatson/puppet-vmwaretools.png?branch=master)](http://travis-ci.org/craigwatson/puppet-vmwaretools)

Introduction
------------

This module manages the installation of VMware Tools via the source code tarballs distributed with vSphere.

Actions:

* Transfer the VMware Tools tarball to the target agent
* Untar the archive and run vmware-install-tools.pl

Supported Operating Systems:

* Ubuntu 12.04 x86_64 (tested)
* CentOS 6.4 x86_64 (written but untested)
* Debian family (written but untested - reports appreciated)
* RedHat family (written but untested - reports appreciated)

Examples
--------

    class { 'vmwaretools':
      version     = '8.6.5-621624',
      working_dir = '/opt/vmware'
    }


To use the module, place your VMware Tools .tar.gz file within the module's files directory and either declare the class as above or:

    include vmwaretools

Notes
-----

* 
* This module is designed to replace both the OSP packages provided by VMware's repositories and also the open-vm-tools package.
* Installer accepts all defaults.

Copyright and License
---------------------
* Copyright (C) 2012 Craig Watson - <craig@cwatson.org>
* Distributed under the terms of the GNU General Public License v3 - see LICENSE.md for details.
