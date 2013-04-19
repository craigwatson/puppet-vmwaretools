puppet-vmwaretools
==================

This module manages the installation of VMware Tools via the source code tarballs distributed with vSphere.

[![Build Status](https://secure.travis-ci.org/craigwatson/puppet-vmwaretools.png?branch=master)](http://travis-ci.org/craigwatson/puppet-vmwaretools)

Actions
-------

* Transfer the VMware Tools tarball to the target agent
* Untar the archive and run vmware-install-tools.pl

Supported Operating Systems
---------------------------

* Ubuntu 12.04 x86_64 (tested)
* Red Hat family (RHEL 6 tested)
* Debian family (written but untested - reports appreciated)

Examples
--------

To accept defaults:

    include vmwaretools

To specify a version and working directory

    class { 'vmwaretools':
      version     => '8.6.5-621624',
      working_dir => '/opt/vmware',
    }

To specify a download location:

    class { 'vmwaretools':
      version            => '9.0.0-782409',
      installer_location => 'http://server.local/VMwareTools-9.0.0-782409.tar.gz',
      installer_md5      => '9df56c317ecf466f954d91f6c5ce8a6f',
    }

Notes
-----

* This module is designed to replace both the OSP packages provided by VMware's repositories and also the `open-vm-tools` package.
* Installer accepts all defaults.

Copyright and License
---------------------

* Copyright (C) 2013 Craig Watson - <craig@cwatson.org>
* VMware Tools fact adapted from https://github.com/janorn/puppet-vmwaretools
* Distributed under the terms of the GNU General Public License v3 - see LICENSE file for details.
