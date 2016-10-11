class gerrit (
  $target                   = '/opt/gerrit',
  #$source                   = "/opt/gerrit/gerrit-2.8.1.war",
  $source                   = "/opt/gerrit/gerrit-2.12.1.war",
  $auth_type                = 'OPENID',
  $canonicalweburl          = 'http://agent3.example.com:8090/',
  $httpd_protocol           = 'http',
  $httpd_hostname           = 'agent3.example.com',
  $httpd_port               = 8090,
  $configure_gitweb         = true,
  $database_backend         = 'h2',
  $database_name            = 'db/ReviewDB',
  $download_scheme          = ['ssh', 'anon_http', 'http'],
  $git_package              = $gerrit::params::git_package,
  $gitweb_cgi_path          = $gerrit::params::gitweb_cgi_path,
  $gitweb_package           = $gerrit::params::gitweb_package,
  $install_git              = true,
  $install_gitweb           = true,
  $install_java             = true,
  $install_java_mysql       = true,
  $install_user             = true,
  $java_package             = $gerrit::params::java_package,
  $manage_service           = true,
  $mysql_java_connector     = $gerrit::params::mysql_java_connector,
  $mysql_java_package       = $gerrit::params::mysql_java_package,
  $user                     = 'gerrit',
  $extra_folders            = ['hooks', 'plugins'],
#  $warsource                = 'https://www.gerritcodereview.com/download/gerrit-2.8.1.war'
  $warsource                = 'https://gerrit-releases.storage.googleapis.com/gerrit-2.12.1.war'
) inherits gerrit::params {

  if $install_user {
    user {
      $user:
        managehome => true,
        home       => $target,
    } -> Exec ['install_gerrit']
  }

#  if $install_java {
#    package{
#      $java_package:
#        ensure => installed,
#    } -> Exec ['install_gerrit']
# }

  if $install_git {
    package{
      $git_package:
        ensure => installed,
    } -> Exec ['install_gerrit']
  }
#  gerrit::folder { $target : } ->
file{"${target}":
      ensure  => directory,
      owner   => $gerrit::user,
      group   => $gerrit::user,
      mode    => '0755',
} ->
exec {
   'wget_gerrit':
     command => "wget ${warsource} -P ${target}",
     # timeout => 50,
     path    => '/usr/bin',

    #onlyif  => "test ! -f /opt/gerrit/gerrit-2.8.1.war",
     onlyif  => "test ! -f /opt/gerrit/gerrit-2.12.1.war",
   } -> Exec ['install_gerrit']
  exec {
    'install_gerrit':
      command => "java -jar ${source} init -d /opt/gerrit/site --batch --install-plugin download-commands",
      creates => "/opt/gerrit/site/bin/gerrit.sh",
      user    => $user,
      path    => $::path,
      require => Exec ['wget_gerrit'],
  }

  exec {
    'reload_gerrit':
     command     => "/opt/gerrit/site/bin/gerrit.sh stop && java -jar ${source} init --batch  -d ${target}",
      refreshonly => true,
      user        => $user,
      path        => $::path,
      notify      => Service['gerrit'],
  }

  if $manage_service {
    service {
      'gerrit':
        ensure    => running,
        start     => "/opt/gerrit/site/bin/gerrit.sh start",
        stop      => "/opt/gerrit/site/bin/gerrit.sh stop",
        hasstatus => false,
        pattern   => 'GerritCodeReview',
        provider  => 'base',
        require   => Exec ['install_gerrit'],
    }
  }

  gerrit::folder { $extra_folders : }

  Gerrit::Config {
    file    => "/opt/gerrit/site/etc/gerrit.config",
  }

  gerrit::config {
    'httpd.listenUrl':
      ensure => present,
      value  => "${httpd_protocol}://${httpd_hostname}:${httpd_port}",
  }

  gerrit::config {
    'database.type':
      ensure => present,
      value  => $database_backend,
  }

  gerrit::config {
    'database.database':
      ensure => present,
      value  => $database_name,
  }

  gerrit::config {
    'auth.type':
      ensure => present,
      value  => $auth_type,
  }
  gerrit::config {
    'plugin.allowRemoteAdmin':
      ensure => present,
      value  => true  ,
  }

  gerrit::config {
    'gerrit.canonicalWebUrl':
      ensure => present,
      value  => $canonicalweburl,
  }

  gerrit::config {
    'download.scheme':
      ensure => present,
      value  => $download_scheme,
  }

  if $install_gitweb {
    package {
      $gitweb_package:
        ensure => installed
    }
  }

  if $configure_gitweb {
    gerrit::config {
      'gitweb.cgi':
        ensure => present,
        value  => $gitweb_cgi_path,
    }
  }
}
