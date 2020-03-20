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
echo opendatahub-operator alpha https://github.com/tmckayus/opendatahub-tests >> my-list
./setup.sh my-list
./operator-tests/run.sh
```

You can run tests individually by passing a substring to run.sh to match:

```bash
./operator-tests/run.sh cr.sh
./operator-tests/run.sh nb.sh
```

# Basic *cr.sh* test

The *cr.sh* test will create an opendatahub instance
from the included *odh.yaml* if an instance doesn't
already exist. If the test creates an instance, it will
also delete it. Therefore, you are free to create an
instance manually before running the test (see *nb.sh* below).

The test checks basic deployment of jupyterhub and the
spark operator.

# Notebook test *nb.sh*

The *nb.sh* test will look for a singleuser-server pod
that has a **SPARK_CLUSTER** environment variable set. If such
a pod is found, it gets the name of the spark cluster
and verifies that the number of workers matches the number
of instances specified in the spark cluster configmap. If there
is no singleuser-server pod, the test passes silently.

The steps to run this test are:

* Create an opendatahub instance manually because any instance created by the *cr.sh*
  test will be deleted.

  ```bash
  oc project opendatahub-operator
  oc create -f odh.yaml
  ```
  
* Launch a server from jupyterhub that uses spark (for example, use the *s2i-spark-minimal-notebook* image)

* Run the tests (all of them, or just *nb.sh*, your choice)

  ```bash
  ./operator-tests/run.sh
  ```
