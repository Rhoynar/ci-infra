class zuul::configs (
$project_name = '',
$job1_name = '',
$job2_name = '',
$job3_name = '',
$job4_name = '',
$jenkins_url = '',
$jenkins_username = '',
$jenkins_password = '',
$node = '',
$zuul_cloner_url = '',
$git_push_url = '',
$gerrit_usename = '',
$gerrit_password = '',
)  {

file { ['/etc/jenkins_jobs/','/etc/jenkins_jobs/jobs/']:
    ensure  => directory,
    }
#file { '/var/lib/zuul/ssh/id_rsa':
#    ensure  => present,
#    owner   => zuul,
#    mode    => '0400',
#    content => template('zuul/id_rsa.erb'),
#    require => File['/var/lib/zuul/ssh/'],
 # }
file { '/etc/jenkins_jobs/jenkins_jobs.ini':
    ensure  => present,
    mode    => '0644',
    content => template('zuul/jenkins_jobs.ini.erb'),
    require => File['/etc/jenkins_jobs/'],
  }
file { '/etc/jenkins_jobs/jobs/jjb.yaml':
    ensure  => present,
    mode    => '0644',
    content => template('zuul/jjb.yaml.erb'),
    require => File['/etc/jenkins_jobs/jobs'],
  }

exec {'jenkins_job':
command => 'jenkins-jobs  -l 3 --conf /etc/jenkins_jobs/jenkins_jobs.ini update /etc/jenkins_jobs/jobs',
   path        => '/usr/local/bin:/usr/bin:/bin/',
    require     => [
      File['/etc/jenkins_jobs/jenkins_jobs.ini'],
      File['/etc/jenkins_jobs/jobs/jjb.yaml'],
      ]
}
file { '/etc/zuul/layout/layout.yaml':
    ensure  => present,
    mode    => '0644',
    content => template('zuul/layout.yaml.erb'),
  }

}
