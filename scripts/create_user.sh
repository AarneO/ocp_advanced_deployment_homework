#!/usr/bin/env bash

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
if [ ! -e "/root/htpasswd.openshift.fixed" ]; then

for passwdline in $(cat /root/htpasswd.openshift)
do
echo $passwdline >> /root/htpasswd.openshift.fixed
done

fi

echo "Adding user $1 to htpasswd file"
htpasswd -b /root/htpasswd.openshift.fixed $1 r3dh4t1!

echo "Syncing file to all masters"
ansible masters -m copy -a "src=/root/htpasswd.openshift.fixed dest=/etc/origin/master/htpasswd" >> /dev/null

echo "create user in ocp"
oc create user $1

echo "add correct environment label to user"
oc label user/$1 client=$2 --overwrite

echo "User created and labeled, password set to environment default"
