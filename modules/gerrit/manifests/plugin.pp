# Define gerrit::plugin
#
# define to install gerrit plugins
#
define gerrit::plugin(
  $source,
  $ensure = 'present',
){

  file{
    "${gerrit::target}/plugins/${name}":
      ensure  => $ensure,
      source  => $source,
      owner   => $gerrit::user,
      group   => $gerrit::user,
      mode    => '0700',
      require => [Exec['install_gerrit'], Gerrit::Folder['plugins']],
  }

}
