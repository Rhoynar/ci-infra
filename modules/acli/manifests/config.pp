# == Class: acli::config
#
# This class configures acli.  It should not be called directly.
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class acli::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/opt/acli/atlassian.sh':
    ensure  => 'file',
    mode    => '0550',
    owner   => 'jenkins',
    group   => 'jenkins',
    content => template("${module_name}/atlassian.sh.erb"),
  }

}
