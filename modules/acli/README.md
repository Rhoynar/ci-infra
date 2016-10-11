[![Puppet Forge](http://img.shields.io/puppetforge/v/evenup/acli.svg)](https://forge.puppetlabs.com/evenup/acli)
[![Build Status](https://travis-ci.org/evenup/evenup-acli.png?branch=master)](https://travis-ci.org/evenup/evenup-acli)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with acli](#setup)
    * [What acli affects](#what-acli-affects)
    * [Beginning with acli](#beginning-with-acli)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Changelog/Contributors](#changelog-contributors)


## Overview

A Puppet module that installs the Atlassian CLI tools from Bob Swift and Appfire.

## Module Description

A Puppet module that installs the Atlassian CLI tools from Bob [Swift and Appfire](https://bobswift.atlassian.net/wiki/dashboard.action) and defines to schedule recurring tasks (via cron).

Please note a license to use the ACLI software is required!  See https://bobswift.atlassian.net/wiki/display/ACLI/Atlassian+CLI+license for details.


## Setup

### What acli affects

* ACLI package
* ACLI cron jobs

### Beginning with acli

Installation of the acli module:

```
  puppet module install evenup-puppet
```

## Usage

Installation:

```puppet
    class { 'acli':
      user        => 'acli',
      password    => 'something secret',
      jira_server => 'https://jira.example.com',
    }
```

To create a quarterly Jira restore test task

```puppet
    acli::jira { 'quarterly_restore_testing':
      project     => 'OPS',
      summary     => 'Quarterly Prouction Restore Test',
      assignee    => 'jlambert',
      description => 'Test restoring production database backups',
      month       => [1,4,7,10],
    }
```


## Reference

### Public methods

#### Class: acli

Main class for installing Atlassian CLI by Bob Swift.

#####`user`
String.  Username ACLI jobs should use to connect

#####`password`
String.  Password ACLI jobs should use to connect

#####`bamboo_server`
String.  Base URL for your Atlassian Bamboo server.

Default: ''

#####`confluence_server`
String.  Base URL for your Atlassian Confluence server.

Default: ''

#####`crucible_server`
String.  Base URL for your Atlassian Crucible server.

Default: ''

#####`fisheye_server`
String.  Base URL for your Atlassian Fisheye server.

Default: ''

#####`jira_server`
String.  Base URL for your Atlassian Jira server.

Default: ''

#####`stash_server`
String.  Base URL for your Atlassian Stash server.

Default: ''

#####`source`
String.  Source path to download ACLI

Default: 'https://bobswift.atlassian.net/wiki/download/attachments/16285777'

#####`version`
String.  Version of ACLI to install.  This will also be used to generate the actual filename to download from $source.

Default: '3.9.0'

#### Define: acli::jira

Manages cron jobs to create Jira issues.

#####`project`
String.  Project to create the issue in.

#####`summary`
String.  Summary of the issue.

#####`assignee`
String.  Assignee of the issue.
Default: ''

#####`description`
String.  Description of the issue.

Default: ''

#####`labels`
String.  Labels of the issue. (comma seperated labels)

Default: ''

#####`parent`
String.  Parent issue of this issue.

Default: ''

#####`type`
String.  Type of issue.

Default: task

#####`monthday`
String.  Day of the month the issue should be created.

Default: 1

#####`month`
String.  Month the issue should be created.

Default: 1

#####`hour`
String.  Hour of the day the issue should be created.

Default: 0

#####`minute`
String.  Minute of the day the issue should be created.

Default: 1

#####`weekday`
String.  Day of the week the issue should be created

Default: *

#####`ensure`
String.  Should the job be present?

Default: present

### Private classes

* `acli::config`: Configures ACLI settings
* `acli::install`: Installs ACLI

## Limitations

* Requires ACLI license - see: https://bobswift.atlassian.net/wiki/display/ACLI/Atlassian+CLI+license
* Only supports Jira issue creation at this time

## Development

Improvements and bug fixes are greatly appreciated.  See the [contributing guide](https://github.com/evenup/evenup-acli/CONTRIBUTING.md) for
information on adding and validating tests for PRs.


## Changelog / Contributors

[Changelog](https://github.com/evenup/evenup-acli/blob/master/CHANGELOG)

[Contributors](https://github.com/evenup/evenup-acli/graphs/contributors)
