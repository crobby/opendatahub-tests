#!/bin/bash

source $TEST_DIR/common

MY_DIR=$(readlink -f `dirname "${BASH_SOURCE[0]}"`)

os::test::junit::declare_suite_start "$MY_SCRIPT"

function test_ai_library() {
    os::cmd::expect_success "oc project opendatahub"
    os::cmd::expect_success_and_text "oc get deployment ailibrary-operator" "ailibrary-operator"
    os::cmd::expect_success_and_text "oc get pod -lcomponent.opendatahub.io/name=ailibrary" "ailibrary-operator"
}

function test_odhargo() {
    os::cmd::expect_success "oc project opendatahub"
    os::cmd::expect_success_and_text "oc get deployment argo-server" "argo-server"
    os::cmd::expect_success_and_text "oc get pod -lcomponent.opendatahub.io/name=odhargo" "argo-server"
    os::cmd::expect_success_and_text "oc get pod -lcomponent.opendatahub.io/name=odhargo" "workflow-controller"
}

function test_grafana() {
    os::cmd::expect_success "oc project opendatahub"
    os::cmd::expect_success_and_text "oc get deployment grafana-operator" "grafana-operator"
    os::cmd::expect_success_and_text "oc get pod -lname=grafana-operator" "grafana-operator"
    os::cmd::expect_success_and_text "oc get pod -lcomponent.opendatahub.io/name=odhargo" "workflow-controller"
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

os::test::junit::declare_suite_end
