#!/bin/bash

source $TEST_DIR/common

MY_DIR=$(readlink -f `dirname "${BASH_SOURCE[0]}"`)

source ${MY_DIR}/util

os::test::junit::declare_suite_start "$MY_SCRIPT"

function test_ai_library() {
    header "Testing AI Library installation"
    os::cmd::expect_success "oc project opendatahub"
    os::cmd::expect_success_and_text "oc get deployment ailibrary-operator" "ailibrary-operator"
    runningpods=($(oc get pods -l name=ailibrary-operator --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningpods[@]}" "1"
}

function test_odhargo() {
    header "Testing ODH Argo installation"
    os::cmd::expect_success "oc project opendatahub"
    os::cmd::expect_success_and_text "oc get deployment argo-server" "argo-server"
    runningpods=($(oc get pods -l app=argo-server --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningpods[@]}" "1"
    runningpods=($(oc get pods -l app=workflow-controller --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningpods[@]}" "1"
}

function test_grafana() {
    header "Testing ODH Grafana installation"
    os::cmd::expect_success "oc project opendatahub"
    os::cmd::expect_success_and_text "oc get deployment grafana-operator" "grafana-operator"
    runningpods=($(oc get pods -l name=grafana-operator --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningpods[@]}" "1"
    runningpods=($(oc get pods -l app=grafana --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningpods[@]}" "1"
    os::cmd::expect_success_and_text "oc get grafanadashboard" "odh-kafka"
    os::cmd::expect_success_and_text "oc get grafanadatasource" "odh-datasource"
}

function test_kafka() {
    header "Testing ODH Strimzi Kafka installation"
    os::cmd::expect_success "oc project opendatahub"
    os::cmd::expect_success_and_text "oc get deployments -n openshift-operators" "strimzi-cluster-operator"
    runningbuspods=($(oc get pods -n openshift-operators -l name=strimzi-cluster-operator --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningbuspods[@]}" "1"
    os::cmd::expect_success_and_text "oc get kafka" "odh-message-bus"
    os::cmd::expect_success_and_text "oc get deployments" "odh-message-bus-entity-operator"
    runningbuspods=($(oc get pods -l app.kubernetes.io/instance=odh-message-bus --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningbuspods[@]}" "7"
}

function test_superset() {
    header "Testing ODH Superset installation"
    os::cmd::expect_success "oc project opendatahub"
    os::cmd::expect_success_and_text "oc get deploymentconfig superset" "superset"
    runningpods=($(oc get pods -l app=superset --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningpods[@]}" "1"
}

function test_prometheus() {
    header "Testing ODH Prometheus installation"
    runningbuspods=($(oc get pods -l k8s-app=prometheus-operator --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningbuspods[@]}" "1"
    runningbuspods=($(oc get pods -l app=prometheus --field-selector="status.phase=Running" -o jsonpath="{$.items[*].metadata.name}"))
    os::cmd::expect_success_and_text "echo ${#runningbuspods[@]}" "1"
}
# function create_cr() {

#     # If there is not an odh already, make one, and clean it up after
#     # This lets us deploy by hand so that we can run manual tests like nb.sh
#     local deployed_odh
#     deployed_odh=false
#     odh=($(oc get opendatahub))
#     if [ "${#odh[@]}" -eq 0 ]; then
# 	deployed_odh=true
#         os::cmd::expect_success "oc create -f $MY_DIR/odh.yaml"
#     fi
    
#     # Note, we're supposed to be able to count arrays in jsonpath with ".items.length" for example,
#     # but it doesn't seem to work. So instead, we dump the list of names matching a label
#     # into a bash array and check it's length
    
#     # check jupyterhub
#     os::cmd::try_until_not_text "oc get pod -l deploymentconfig=jupyterhub" "No resources found"
#     cnt=($(oc get pod -l deploymentconfig=jupyterhub -o jsonpath="{$.items[*].metadata.name}"))
#     os::cmd::expect_success_and_text "echo ${#cnt[@]}" "1"

#     # check jupyterhub-db
#     os::cmd::try_until_not_text "oc get pod -l deploymentconfig=jupyterhub-db" "No resources found"
#     cnt=($(oc get pod -l deploymentconfig=jupyterhub-db -o jsonpath="{$.items[*].metadata.name}"))
#     os::cmd::expect_success_and_text "echo ${#cnt[@]}" "1"

#     # check spark-operator
#     os::cmd::try_until_not_text "oc get pod -l 'app.kubernetes.io/name'=spark-operator" "No resources found"
#     cnt=($(oc get pod -l 'app.kubernetes.io/name'=spark-operator -o jsonpath="{$.items[*].metadata.name}"))
#     os::cmd::expect_success_and_text "echo ${#cnt[@]}" "1"

#     if [ "$deployed_odh" == true ]; then
#         os::cmd::expect_success "oc delete opendatahub --all"
#         os::cmd::try_until_text "oc get pod -l deploymentconfig=jupyterhub" "No resources found"
#         os::cmd::try_until_text "oc get pod -l deploymentconfig=jupyterhub-db" "No resources found"
#         os::cmd::try_until_text "oc get pod -l 'app.kubernetes.io/name'=spark-operator" "No resources found"
#     fi
# }

# create_cr
test_ai_library
test_odhargo
test_grafana
test_kafka
test_superset
test_prometheus

os::test::junit::declare_suite_end
