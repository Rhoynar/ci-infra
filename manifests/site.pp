node 'agent1.example.com'{
		class { 'postgresql::server': } ->

		postgresql::server::db { 'jira':
	 			user     => 'jiraadm',
	  		password => postgresql_password('jiraadm', 'mypassword'),
	 	} ->
		file { '/usr/java/':
	  		ensure => 'directory',
		} ->
		java::oracle { 'jdk8' :
	  		ensure  => 'present',
				version => '8',
	  		java_se => 'jdk',
		} ->
		class { 'jira':
	 			javahome    => '/usr/java/jdk1.8.0_51',
	 	}
}

node 'agent2.example.com'{
		include jenkins
    		include jenkins::master
    	    	jenkins::plugin { 'gerrit-trigger': }
	    	jenkins::plugin { 'gearman-plugin': }
	    	jenkins::plugin { 'workflow-aggregator': }

	   	class { 'acli':
			version     => '5.0.0',
			user        => '',
  			password    => '',
  			jira_server => 'http://agent1.example.com:8080',
		}
		class { 'zuul': }
}

node 'agent3.example.com'{
		class { 'jenkins::slave':
	    		masterurl => 'http://agent2.example.com:8080',
	    		ui_user => '',
	    		ui_pass => '',
		} ->

		class { 'gerrit':
			canonicalweburl => 'http://agent3.example.com:8090/',
		        httpd_hostname  => 'agent3.example.com',
		        httpd_port      => '8090',
		}
}

node 'agent4.example.com'{
		class { 'zuul':
			gerrit_server => 'agent3.example.com',
			gerrit_user => 'admin',
			gearman_server => 'agent4.example.com',
			zuul_url =>'http://agent4.example.com/p',
			gerrit_baseurl => 'http://agent3.example.com:8090',
			zuul_ssh_private_key => '/var/lib/zuul/ssh/id_rsa',
		}->
		class { 'zuul::launcher':
			ensure => 'running',
		}->
		class {	'zuul::merger':
			ensure => 'running',
    		}->
		class { 'zuul::server':
			ensure => 'running',
			layout_dir => '/etc/zuul/layout/',
		}~>
		exec { 'zuul-restart':
			command => '/etc/init.d/zuul restart && /etc/init.d/zuul-merger restart',
			refreshonly => true,
		}
		class { 'zuul::known_hosts' :
		known_hosts_content => '',
		}
		class { 'zuul::configs':
        		project_name => 'final-test',
        		job1_name => 'dev-unit-tests-before-merge-prod',
			job2_name => 'dev-unit-test-patchset',
			job3_name => 'code-review-rejection',
			job4_name => 'copy-dev-merge-to-prod',
        		jenkins_url => 'http://agent2.example.com:8080',
        		jenkins_username => '',
        		jenkins_password => '',
			gerrit_usename => '',
			gerrit_password => '',
        		node => 'master',
        		zuul_cloner_url => 'http://agent3.example.com:8090',
			git_push_url => 'agent3.example.com:8090',
		}
}

node default{
		user {'test':
			ensure => 'present',
		}
}
