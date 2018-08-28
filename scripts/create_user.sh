#!/usr/bin/env bash
export GUID=`hostname|awk -F. '{print $2}'`

usage ()
{
  echo 'Usage : create_user.sh <username> <environment>'
  echo 'Choose the name, use one of the three environments: alpha, beta, common'
  exit
}

if [ "$#" -ne 2 ]
then
  usage
fi

# Fixing the given htpasswd file (no line change in the end)
for passwdline in $(cat /root/htpasswd.openshift)
do
echo $passwdline >> /root/htpasswd.openshift.fixed
done

echo "Adding user to htpasswd file"
htpasswd -b /root/htpasswd.openshift.fixed $1 r3dh4t1!

echo "Syncing file to all masters"
ansible masters -m copy -a "src=/root/htpasswd.openshift.fixed dest=/etc/origin/master/htpasswd"

echo "verify login"
oc login https://loadbalancer1.$GUID.internal:8443 --username=$1 --password=r3dh4t1! --insecure-skip-tls-verify=false
oc login -u system:admin

echo "add correct environment label to user"
oc label user/$1 client=$2

echo "User created and labeled, password set to environment default"
