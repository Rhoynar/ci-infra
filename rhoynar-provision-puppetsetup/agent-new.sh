#!/bin/bash
#This script designed for setup of puppet agent in debian jessie#
export DEBIAN_FRONTEND=noninteractive
while getopts ":m:H:a:h:i:" OPTION
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
        i)
            agentName="${OPTARG}"
            ;;

	esac
done

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
        echo "Agent Initial must be set in vagrantfile"
        echo "Kindly destroy the newly launched box and try again with providing all required parameters in Vagrantfile"
        exit 1
fi

if [  "$agentIP" == ""  ]
        then
        echo "Agent IP address  must be set in vagrantfile"
        echo "Kindly destroy the newly launched box and try again with providing all required parameters in Vagrantfile"
        exit 1
fi
if [  "$agentName" == ""  ]
        then
        echo "Agent Name  must be set in vagrantfile"
        echo "Kindly destroy the newly launched box and try again with providing all required parameters in Vagrantfile"
        exit 1
fi
hostname1="$agentName"
masterhost="$masterIP   $host1.example.com $host1 puppet"
server='puppet'
certname="$agentName.example.com"

agent_count=1

for agent in ${agentIP}
do
echo "${agent}  ${agentInitial}${agent_count}.example.com ${agentInitial}${agent_count}" >> /etc/hosts
agent_count=$((agent_count+1))
done

#setting hostname of server 
echo $hostname1 > /etc/hostname
hostname $hostname1

#Adding hostentries
echo $masterhost >> /etc/hosts

#installing puppet-agent
 /usr/bin/apt-get -y update
 #/usr/bin/apt-get -y install libssl1.0.0
 /usr/bin/apt-get -y install puppet

#puppet configuration
echo '[agent]' >> /etc/puppet/puppet.conf
echo "server = $server" >> /etc/puppet/puppet.conf
echo "certname = $certname" >> /etc/puppet/puppet.conf

# Starting puppet-agent
service puppet restart
puppet agent --enable
sleep 3
echo "Kindly wait $agentName is fetching and applying catlogs from puppet master..!! DO NOT EXIT.."
#echo `puppet agent --test` >> /dev/null 2>&1
#puppet agent --test 

exit 0
