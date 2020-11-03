#!/bin/bash
#
#       Script to install and remove custom version of puppet
#
if [ $# -eq 0 ]; then
    echo $'Invalid parameter\nUsage:\n$0 -i : installs puppet\n$0 -r : remove puppet'
    exit 1
fi

case "$1" in
        -i|--install)
                echo $'Installing rpm..'
                rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-6.noarch.rpm
                yum clean all; yum makecache
                echo $'Rpm installed!\nYum install...'
                yum install puppet-agent --disablerepo="*" --enablerepo="puppet5"
                echo $'Yum install completed!\nCreating symlinks...'
                cd /bin
                ln -s /opt/puppetlabs/bin/puppet puppet
                ln -s /opt/puppetlabs/bin/facter facter
                ln -s /opt/puppetlabs/bin/hiera hiera
                echo $'Installation completed.'
                ;;
        -r|--remove)
                echo $'Yum remove..'
                yum remove puppet
                echo $'Yum remove completed.\nRpm clean....'
                rpm -e $(rpm -qa | grep puppet | head -n 1)
                echo $'Rpm clean completed.\nYum cleaning..'
                yum clean all; yum makecache
                echo $'Yum cleaning completed.'
                cd /bin
                rm -f puppet
                rm -f facter
                rm -f hiera
                echo $'Uninstalling completed.'
                ;;
        -h|--help)
                echo $'Invalid parameter\nUsage:\n$0 -i : installs puppet\n$0 -r : remove puppet'
                ;;
        --default)
                echo $'Invalid parameter\nUsage:\n$0 -i : installs puppet\n$0 -r : remove puppet'
                exit 1
                ;;
esac
