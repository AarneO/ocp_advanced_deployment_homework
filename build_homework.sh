#!/usr/bin/env bash
export GUID=`hostname|awk -F. '{print $2}'`

echo ""
echo "This will build the Openshift Advanced Deployment Homework Assignment"
echo ""
echo "GUID for the environment seems to be $GUID, bulding the inventory file with that"
echo ""
ansible-playbook -e "guid=$GUID" homework.yaml --tags "config"
echo "Starting OpenShift deployment"
ansible-playbook -e "guid=$GUID" homework.yaml --skip-tags "config"