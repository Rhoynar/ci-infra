# Define gerrit::repository
#
# define to create empty git bare repositories
#
define gerrit::repository {

  $directory = "${gerrit::target}/git/${name}.git"

  exec{ "gerrit_create_${name}":
      command => "mkdir -p '${directory}' && cd '${directory}' && git init --bare",
      creates => "${directory}/config",
      user    => $gerrit::user,
      path    => $::path,
      require => Exec['install_gerrit'],
  }

  if $gerrit::manage_service {
    Exec["gerrit_create_${name}"] ~> Exec['reload_gerrit']
  }


}
