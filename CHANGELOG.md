# 1.4.0 - 2019-08-29

* [image] add helmfile

# 1.3.3 - 2019-04-25

* [fix] missing build-deps for docker-compose

# 1.3.2 - 2018-10-11

* [ci] fix tag detection

# 1.3.1 - 2018-10-11

* [fix] enable pushing in script
* [ci] now only pushes images when tagged

# 1.3.0 - 2018-10-11

* [image] add kubeadm
* [image] add cfssl
* [image] add cfssljson
* [image] kube version ist now a required build arg
* add script for building, testing and pushing images for different kube version
* [ci] add travis cronjob which builds the image for the latest kube version
* [ci] add travis job which rebuilds the image for the last 4 minor versions of kubernetes

# 1.2.2 - 2018-09-27

## FIXES

* move kubectl binary to /usr/bin/
* make kubectl executeable
* add Dockerfile check for kubectl to ensure it's working

# 1.2.1 - 2018-05-19

* rework README
* introduce bump2version for versioning


# 1.2.0 - 2018-05-16

* [imgae] Install kubectl via curl

# 1.1.1 - 2018-04-09

* [ci] update upstream base image before building our own docker image

# 1.1.0 - 2018-02-16

* [image] update docker from 1.12.6 to 18.x


# 1.0.0

* [image] automatically configure gcloud git helper
* [docs] add example usage of the image as CSR (Cloud Source Repo) syncer in README

