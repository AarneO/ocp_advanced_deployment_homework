#!/usr/bin/env bash
export GUID=`hostname|awk -F. '{print $2}'`

echo ""
echo "This will build the Openshift Advanced Deployment Homework Assignment"
echo ""
echo "GUID for the environment seems to be $GUID, bulding the inventory file with that"
echo ""
echo ansible-playbook -e "guid=$GUID" --tags "config"
echo "Starting OpenShift deployment"
echo ansible-playbook -e "guid=$GUID" --skip-tags "config"
echo ""
smoketest=$(oc get route |grep nodejs-mongo | awk '{print $2}')
echo "Smoke test URL can be found http://$smoketest"
echo ""
