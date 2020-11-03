#!/bin/bash

# source /etc/profile.d/facter.sh

#set -x -e
DOMAIN="localdomain"
# HOSTNAME="${PROJECT}-${ENV}-${FUNCTION}-${NODE}"
# echo "HOSTNAME:  $HOSTNAME"

BRANCH=master

#file paths
HOSTS_FILE="/etc/hosts"
HOSTNAME_FILE="/etc/sysconfig/network"
BITBUCKET_CONF_FILE="/root/.ssh"
BITBUCKET_KEY="/root/.ssh/id_rsa.pub"
KNOW_HOSTS="/root/.ssh/known_hosts"
REPO_NAME="puppet-cis.git"

if [[ -z "${REPO_NAME}" ]]; then
        echo "NO REPO_NAME set... !!"
        exit 3
fi

#bin
GIT="/usr/bin/git"
YUM="/usr/bin/yum"
SED="/bin/sed"
ECHO="/bin/echo"
CHMOD="/bin/chmod"
MKDIR="/bin/mkdir"
HOSTNAME_BIN="/bin/hostname"
PUPPET_FOLDER="/media/ephemeral0/repo-git/"
PUPPET_FILE="node.pp"
if [[ -z "$1" ]]; then
        PUPPET_TAG=""
else
        PUPPET_TAG="--tags $1"
fi
# #edit hostname file
# ${SED} -i "s/HOSTNAME=.*/HOSTNAME=${HOSTNAME}/g" ${HOSTNAME_FILE}
# ${HOSTNAME_BIN} ${HOSTNAME}

# #edit hosts file
# ${ECHO} "127.0.0.1 localhost localhost.${DOMAIN}" > ${HOSTS_FILE}
# ${ECHO} "127.0.0.1 ${HOSTNAME} ${HOSTNAME}.${DOMAIN}" >> ${HOSTS_FILE}

#create puppet folder
${MKDIR} -p ${PUPPET_FOLDER}

#install puppet dependency
#rpm -ivh https://yum.puppetlabs.com/puppet/puppet5-release-el-7.noarch.rpm
${YUM} -y install facter rubygems augeas-libs ruby-shadow ruby-augeas rubygem-json htop git dos2unix

#${ECHO} "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDqgO5B2vE7gNuPHYNSUKKRKiddriLUnaJhiVJ//er3mCuAvzE0wfFlWV5pip1IfmynXmXSY6JMyyBr81LezjnIBqFl4XuP4ng0alF7ha9yE94YBvy2OcrB0klrOFvEzhnrpADPhDeHR7tsIymQhvrpqWrUrV7/8wtPQS+oXE7KxQyiKNhGNimxiwqgiQpp+YRPFiNhcdMkLN78vZ8wxXy/C/aQky+ZPxO3P0bK+jWhRkZKN8kcmWGAhKf0zU8re+V+RyQbi1vu5iLRDmhXoea47T/anoqTVfdMYfTSfUSe7a6hx/WIIlciZkzf0rgE0C+j9BWksM2hShrBH0fs1yIN" > ${BITBUCKET_KEY}

#${CHMOD} 600 ${BITBUCKET_KEY}


#prepare remote git access
${ECHO} "Host bitbucket.org" > ${BITBUCKET_CONF_FILE}
${ECHO} " IdentityFile ${BITBUCKET_KEY}" >> ${BITBUCKET_CONF_FILE}

P_DIR=$( pwd )
#clone the instance git
if [ -d ${PUPPET_FOLDER}/.git ]; then
        cd ${PUPPET_FOLDER}
        ${GIT} pull origin
else
        echo "${GIT} clone --depth=1 -b ${BRANCH} git@YOURGIT/${REPO_NAME} ${PUPPET_FOLDER}"
        echo "------"
        ${GIT} clone --depth=1 -b ${BRANCH} git@YOURGIT/${REPO_NAME} ${PUPPET_FOLDER}
        echo "----"
fi
cd ${P_DIR}

rsync -a -f"- .git/" -f"+ *" ${PUPPET_FOLDER}/puppet/ /etc/puppet/

# Get rid of deprecation warning
export STDLIB_LOG_DEPRECATIONS="false"

# run puppet
 echo "puppet apply ${PUPPET_FOLDER}/puppet/manifests/${PUPPET_FILE} --test --detailed-exitcodes --modulepath=${PUPPET_FOLDER}/puppet/modules ${PUPPET_TAG}"
 puppet apply ${PUPPET_FOLDER}/puppet/manifests/${PUPPET_FILE} --test --detailed-exitcodes --modulepath=${PUPPET_FOLDER}/puppet/modules ${PUPPET_TAG}
 RET=$?
 echo "RET = $RET"

 if [ $RET -eq 1 -o $RET -eq 4 -o $RET -eq 6 ]; then
         exit 1
 fi

exit 0
