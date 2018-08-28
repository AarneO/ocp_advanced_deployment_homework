#!/usr/bin/env bash
export GUID=`hostname|awk -F. '{print $2}'`

echo ""
echo "This will build the Openshift Advanced Deployment Homework Assignment"
echo ""
echo "GUID for the environment seems to be $GUID, bulding the inventory file with that"
echo ""
ansible-playbook -e "guid=$GUID" homework.yaml --tags "config"
ansible-playbook -e "guid=$GUID" homework.yaml --skip-tags "config,postproject"
echo "environment up, running post tasks"
ansible-playbook -e "guid=$GUID" homework.yaml --tags "postproject"
echo ""
echo "Check the results:"
echo "OpenShift Web Console: https://loadbalancer1.$GUID.example.opentlc.com:8443/"
echo "Smoke test application: http://$(oc get route -n smoke-test |grep opentlc.com |awk '{print $2}')"
echo "Prod application in CI/CD Pipeline: http://$(oc get route -n stage-homeworkdemo |grep opentlc.com |awk '{print $2}')"
