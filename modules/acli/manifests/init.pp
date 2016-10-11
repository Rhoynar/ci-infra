# == Class: acli
#
# This class installs and configures the Atlassian CLI tool from Bob Smith (https://bobswift.atlassian.net/wiki/display/JCLI/Documentation).
# NOTE: This tool requires a license, please ensure you are properly licensesd.  https://bobswift.atlassian.net/wiki/display/ACLI/Atlassian+CLI+license
#
#
# === Parameters
#
# [*user*]
#   String.  User to access the Atlassian product with
#   Required
#
# [*password*]
#   String.  Password to access the Atlassian product with
#   Required
#
# [*bamboo_server, confluence_server, crucible_server, fisheye_server, jira_server, stash_server*]
#   String.  Url for the <service> server
#   At least one is required for this to be useful
#
# [*source*]
#   String.  Base URL for the location of the distribution zip
#
# [*version*]
#   String.  Version of the ACLI tool to install
#
#
# === Examples
#
# * Installation:
#     class { 'acli':
#       user      => 'acli_user',
#       password  => 'super_secret'
#     }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class acli (
  $user,
  $password,
  $bamboo_server      = '',
  $confluence_server  = '',
  $crucible_server    = '',
  $fisheye_server     = '',
  $jira_server        = '',
  $stash_server       = '',
  $source             = 'https://bobswift.atlassian.net/wiki/download/attachments/16285777',
  $version            = '3.9.0',
) {

  include java

  class { 'acli::install': } ->
  class { 'acli::config': }

}
