puppet-vmwaretools
==================

This module manages the installation of VMware Tools via the source code tarballs distributed with vSphere.

[![Build Status](https://secure.travis-ci.org/craigwatson/puppet-vmwaretools.png?branch=master)](http://travis-ci.org/craigwatson/puppet-vmwaretools)

Actions
-------

* Compares installed version with the configured version
* Transfer the VMware Tools archive to the target agent (via Puppet or HTTP)
* Untar the archive and run vmware-install-tools.pl
* Removes open-vm-tools

Supported Operating Systems
---------------------------

* Ubuntu (12.04 LTS tested)
* Red Hat family (RHEL 5 and 6 tested)
* Debian family (written but untested - reports appreciated)

Examples
--------

To accept defaults:

    include vmwaretools

To specify a non-default version, working directory and HTTP URL:

    class { 'vmwaretools':
      version     => '8.6.5-621624',
      working_dir => '/tmp/vmwaretools'
      archive_url => 'http://server.local/my/dir',
      archive_md5 => '9df56c317ecf466f954d91f6c5ce8a6f',
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
