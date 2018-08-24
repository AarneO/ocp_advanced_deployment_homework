#!/usr/bin/env bash

usage ()
{
  echo 'Usage : create_project.sh <projectname> <environment>'
  echo 'Choose the name, use one of the three environments: alpha, beta, common'
  exit
}

if [ "$#" -ne 2 ]
then
  usage
fi

oc new-project $1
oc patch namespace $2 -p '{"metadata":{"annotations":{"openshift.io/node-selector":"client=$2"}}}'
if [ $? -eq 0]
then
 echo "Project created, happy deployments"
else
 echo "something went wrong, contact your lousy consultant"
done