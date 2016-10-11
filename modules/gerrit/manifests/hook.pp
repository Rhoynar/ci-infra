# Define gerrit::hook
#
# define to create gerrit hook
#
define gerrit::hook(
  $ensure   = 'present',
  $source   = undef,
  $content  = undef,
){

  file{
    "${gerrit::target}/hooks/${name}":
      ensure  => $ensure,
      source  => $source,
      content => $content,
      owner   => $gerrit::user,
      group   => $gerrit::user,
      mode    => '0700',
      require => [Exec['install_gerrit'], Gerrit::Folder['hooks']],
  }

}
