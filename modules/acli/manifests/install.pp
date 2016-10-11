# == Class: acli::install
#
# This class installs acli.  It should not be called directly.
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class acli::install {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $filename = "atlassian-cli-${acli::version}-distribution.zip"

  ensure_packages('unzip')

  exec { 'fetch_acli':
    command   => "/usr/bin/curl -o ${filename} ${acli::source}/${filename}",
    cwd       => '/tmp',
    creates   => "/tmp/${filename}",
    path      => '/usr/bin/:/bin',
    logoutput => on_failure,
    unless    => "/usr/bin/test -d /opt/atlassian-cli-${acli::version}",
  }

  exec { 'extract_acli':
    command   => "unzip /tmp/${filename} -d /opt/",
    cwd       => '/opt',
    creates   => "/opt/atlassian-cli-${acli::version}",
    path      => '/bin/:/usr/bin/',
    require   => [Exec['fetch_acli'], Package['unzip']],
    logoutput => on_failure,
  }

  file { '/opt/acli':
    ensure  => 'link',
    target  => "/opt/atlassian-cli-${acli::version}",
    require => Exec['extract_acli'],
  }->

file { "/opt/atlassian-cli-${acli::version}":
ensure => 'directory',
owner => jenkins,
require => Exec['extract_acli'],
}

}
