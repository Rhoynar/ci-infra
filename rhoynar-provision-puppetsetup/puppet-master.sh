#!/bin/bash
#This script designed for setup of puppet master in debian jessie#
export DEBIAN_FRONTEND=noninteractive
while getopts ":m:H:a:h:" OPTION
do
	case $OPTION in
		m)
			host1="${OPTARG}"
			;;

		H)
		 	masterIP="${OPTARG}"
			;;
		a)
			agentInitial="${OPTARG}"
			;;
                h)
                        agentIP="${OPTARG}"
                        ;;
	esac
done

echo "Master:$host1"
echo "Master IP: $masterIP"
echo "Agent Initial: $agentIP"

if [  "$host1" == ""  ]
	then
	echo "Hostname must be set in vagrantfile"
        echo "Kindly destroy the newly launched box and try again with providing all required parameters in Vagrantfile"
	exit 1
fi

if [  "$masterIP" == ""  ]
        then
        echo "Master IP address  must be set in vagrantfile"
        echo "Kindly destroy the newly launched box and try again with providing all required parameters in Vagrantfile"
        exit 1
fi

if [  "$agentInitial" == ""  ]
        then
        echo "Agent name must be set in vagrantfile"
        echo "Kindly destroy the newly launched box and try again with providing all required parameters in Vagrantfile"
        exit 1
fi

if [  "$agentIP" == ""  ]
        then
        echo "Agent IP address  must be set in vagrantfile"
        echo "Kindly destroy the newly launched box and try again with providing all required parameters in Vagrantfile"
        exit 1
fi
hostname1="$host1"
masterhost="$masterIP  $host1.example.com $host1 puppet"
certname="$host1.example.com"
dns_alt_name="puppet,$host1,$host1.example.com"
echo "Agent Initial: $agentInitial"

#setting hostname of server 
echo $hostname1 > /etc/hostname
hostname $hostname1

#Adding hostentries
echo $masterhost >> /etc/hosts

#installing puppetserver
/usr/bin/apt-get -y update
#/usr/bin/apt-get -y install libssl1.0.0
/usr/bin/apt-get -y install puppetmaster
/usr/bin/apt-get -y install git
agent_count=1
for agent in ${agentIP}
do
echo "${agentInitial}${agent_count}.example.com" >> /etc/puppet/autosign.conf
echo "${agent}  ${agentInitial}${agent_count}.example.com" >> /etc/hosts
agent_count=$((agent_count+1))
#ping -c 2 agent${agent_count}.example.com
done

chmod 644 /etc/puppet/autosign.conf

#configuring puppet-server
echo "certname = $certname" >> /etc/puppet/puppet.conf
echo "dns_alt_names = $dns_alt_name" >> /etc/puppet/puppet.conf

echo "autosign = /etc/puppet/autosign.conf" >> /etc/puppet/puppet.conf

# Starting puppetserver
service puppetmaster restart
cd /tmp/ && git clone https://github.com/sagarinitcron/rhoynar-devops-automation.git
mv -f /tmp/rhoynar-devops-automation/* /etc/puppet/

echo 'Puppet server is installed and configured successfully..!!'
