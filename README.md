# Basic opendatahub tests and how to use them

This test repository is meant to be used with the
test runner [located here](https://github.com/tmckayus/peak),
see the README.md there for complete information.

The intial tests here verify deployment of an opendatahub
instance including jupyterhub and the spark operator.

There is also a test that verifies the deployment of a
notebook server and spark cluster. This test requires
that the server be started manually from jupyterhub.

# Quick start

Make sure you have an OpenShift login, then do the following:

```bash
git clone https://github.com/tmckayus/peak
cd peak
git submodule update --init
echo opendatahub-kubeflow alpha https://github.com/crobby/opendatahub-tests >> my-list
./setup.sh my-list
./operator-tests/run.sh
```

You can run tests individually by passing a substring to run.sh to match:

```bash
./operator-tests/run.sh basictests.sh
```

# Basic *basictests.sh* test

This set of tests assumes that you have opendatahub (Kubeflow-based) isntalled.  It
then goes through each module and tests to be sure that the expected pods are all
in the running state.  This is meant to be the barebones basic smoke tests for an installation.
The steps to run this test are:

* Run the tests

  ```bash
  ./operator-tests/run.sh
  ```
