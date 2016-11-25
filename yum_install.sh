#!/bin/bash

#Import environment variables
export PWD=`pwd`
export YUM=/yum
export CentOS=/x/os/CentOS_7_x86_64
chmod 755 *.sh

#Configure the local yum source
echo "================ Install yum start ================"
echo "This may take a few minutes ... "
if [ -d ${YUM} ]; then
	rm -rf ${YUM}
fi
mkdir ${YUM}
chmod 777 ${YUM}
cp -rf ${CentOS}/Packages ${YUM}/

rpm -ivh ${YUM}/Packages/deltarpm*
rpm -ivh ${YUM}/Packages/python-deltarpm*
rpm -ivh ${YUM}/Packages/createrepo*
createrepo ${YUM}

#Configure yum file
mv /etc/yum.conf /etc/yum.conf.bak
echo "
[main]
cachedir=/var/cache/yum
keepcache=0
debuglevel=2
logfile=/var/log/yum.log
distroverpkg=redhat-release
tolerant=1
exactarch=1
obsoletes=1
gpgcheck=0
plugins=1
installonly_limit=5
" > /etc/yum.conf

if [ -d /etc/yum.repos.d/bak ]; then
	rm -rf /etc/yum.repos.d/bak
fi
mkdir /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/
echo "
[localyum]
Name=localyum 
baseurl=file:///yum
enable=1
gpgcheck=0
" > /etc/yum.repos.d/localyum.repo

cd ${YUM}
yum clean all
yum list

echo "================ Install yum end ================"
