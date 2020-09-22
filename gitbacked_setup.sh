#!/bin/bash

# Load bitnami libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libwebserver.sh

if [ -z "$SSH_RSA_KEY" -o -z "$GIT_REPO" -o -z "$GIT_FINGERPRINT" ]; then
  info "DOKU_GITBACKED: Variables SSH_RSA_KEY, GIT_REPO, GIT_FINGERPRINT must be set for gitbacked to funciton"; exit;
fi

# Get DAEMON user homedir
homedir=$( getent passwd "bitnami" | cut -d: -f6 )
userid=$( id -u )
# Setup SSH for DAEMON user
echo $GIT_FINGERPRINT | base64 -d > $homedir/.ssh/known_hosts
echo $SSH_RSA_KEY | base64 -d > $homedir/.ssh/id_rsa 

# Permissions
chown $userid:0 $homedir/.ssh -R
chmod 700 $homedir/.ssh -R
chmod 600 $homedir/.ssh/id_rsa


if [ ! -d "/bitnami/dokuwiki/data/docs" ]; then
    info "DOKU_GITBACKED: Cloning GIT_REPO to /bitnami/dokuwiki/data/docs"
    git clone $GIT_REPO /bitnami/dokuwiki/data/docs

    info "DOKU_GITBACKED: Setting GIT CONFIG local properties"
    cd /bitnami/dokuwiki/data/docs
    git config --local user.name dokuwiki
    git config --local user.email $DOKUWIKI_EMAIL
else
    info "DOKU_GITBACKED: /bitnami/dokuwiki/data/docs already exists"
fi

info "DOKU_GITBACKED: note - you may need to update DOKUWIKI global conf to use the directories within /bitnami/dokuwiki/data/docs"