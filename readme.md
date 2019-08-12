# DokuWiki

In brief, this container is an extension of the [bitnami/dokuwiki](hub.docker.com/r/bitnami/dokuwiki) to add appropriate SSH settings to the `daemon` user running apache.

**_THIS IS A DROP IN REPLACEMENT FOR BITNAMI/DOKUWIKI_** - it works exactly the same, just change the name of the container. It _shouldn't_ break anything.

## Environment Variables

* `SSH_RSA_KEY` - base64 encoded private RSA key used to access the repository. May need write access.
  * Probably want to setup a deploy key for your repo. Links for [GitHub](https://developer.github.com/v3/guides/managing-deploy-keys/) and [GitLab](https://docs.gitlab.com/ee/ssh/README.html#deploy-keys)
  * To encode it: `cat id_rsa | base64 -w 0`
* `GIT_REPO` - SSH URL to access the repo. Will look like this: `git@github.com:SoarinFerret/doku.git`
* `GIT_FINGERPRINT` -  Base64 encoded fingerprints for your git provider
  * Easiest way to generate this: `ssh-keyscan github.com | base64 -w 0`

## How this works

Pretty simple, I inject a script into the bitnami container called `gitbacked_setup.sh`, and then sed the `app-entrypoint.sh` to run my script after it does its thing.

### Kubernetes? You got it

Thats actually the reason I made this! I alterned the bitnami [helm chart](https://github.com/helm/charts/tree/master/stable/dokuwiki) for dokuwiki, replacing the image and adding the extra environment variables.

I added 3 new values:

* sshRsaKey - refers to SSH_RSA_KEY. This is transformed into a k8s secret
* gitRepo - refers to GIT_REPO
* gitFingerprint - refers to GIT_FINGERPRINT

```bash
RSA=$(cat id_rsa | base64 -w0 )
FINGER=$(ssh-keyscan gitlab.com | base64 -w 0)
URL="git@gitlab.com:thisisnotarealrepo/ihope.git"

helm install --name dokuwiki ./dokuwiki-helm \
    --set dokuwikiUsername=notadmin,dokuwikiPassword=muahahahaha,sshRsaKey=$RSA,gitFingerprint=$FINGER,gitRepo=$URL
```
