# Docker image: claranet/gcloud-kubectl-docker

This is a helper image useful in CI/CD jobs. Its been necessary to roll our
very own one, because the plentytude available out there are not getting
updates anymore. So we needed a current version of those tools.


# Use this image to...

## ...push to gcloud source repo

**gitlab-ci.yaml**

Variables to be injected by gitlab ci secrets:
* GCLOUD_SERVICEACCOUNT_KEYFILE => the json content of the service account key
* GCLOUD_PROJECT => GCP project ID
* GCLOUD_ZONE => GCP zone
* GCLOUD_REPO => repo name in GCP

```yaml
.configure_gcloud: &configure_gcloud |
  echo "$GCLOUD_SERVICEACCOUNT_KEYFILE" > $GCLOUD_KEYFILE_PATH
  gcloud auth activate-service-account --key-file $GCLOUD_KEYFILE_PATH
  gcloud config set project $GCLOUD_PROJECT
  gcloud config set compute/zone $GCLOUD_ZONE

# clean up job
after_script:
  - "[ ! -e $GCLOUD_KEYFILE_PATH ] || rm -f $GCLOUD_KEYFILE_PATH"

# the actual job:
myjob:
  stage: deploy
  image: claranet/gcloud-kubectl-docker
  environment:
    name: GCR
    url: https://console.cloud.google.com/code/develop/browse/${GCLOUD_REPO}/master?project=${GCLOUD_PROJECT}
  variables:
    GCLOUD_KEYFILE_PATH: "/tmp/${GCLOUD_PROJECT}.iam.gserviceaccount.com.json"
    GIT_STRATEGY: "clone"
    GIT_CHECKOUT: "true"
  script:
    - *configure_gcloud
    - git checkout $CI_COMMIT_REF_NAME
    - git remote add google https://source.developers.google.com/p/${GCLOUD_PROJECT}/r/${GCLOUD_REPO}
    - git push --all google
    - git push --tags google
```
