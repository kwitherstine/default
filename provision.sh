#!/bin/bash

function error() {
  echo -e "\e[0;33mERROR: Provisioning error running $BASH_COMMAND at line $BASH_LINENO of $(basename $0) \e[0m" >&2
}

# Log all output from this script
exec >/var/log/autoprovision 2>&1

echo "Showing all commands from the script"
set -x

trap error ERR

URL="http://192.168.0.1/authorized_keys"

mkdir -p /root/.ssh
/usr/bin/wget -O /root/.ssh/authorized_keys $URL
mkdir -p /home/cumulus/.ssh
/usr/bin/wget -O /home/cumulus/.ssh/authorized_keys $URL
chown -R cumulus:cumulus /home/cumulus/.ssh
/usr/bin/wget -O /etc/network/interfaces http://192.168.0.1/interfaces

sudo apt-get update
sudo apt-get -y dist-upgrade

echo "ZTP is updating MOTD" | wall -n
echo "'hostname' is ALIVE thanks to ZTP" > /etc/motd

echo "ZTP is Installing the license File" | wall -n
sudo cl-license -i http://192.168.0.1/'hostname'.lic
sudo service switchd restart


#CUMULUS-AUTOPROVISIONING

exit 0
