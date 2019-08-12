#!/bin/sh

if [ -z "$SSH_RSA_KEY" -o -z "$GIT_REPO" -o -z "$GIT_FINGERPRINT" ]; then
  echo "DOKU_GITBACKED: Variables SSH_RSA_KEY, GIT_REPO, GIT_FINGERPRINT must be set for gitbacked to funciton"; exit;
fi

# Get DAEMON user homedir
homedir=$( getent passwd "daemon" | cut -d: -f6 )

# Setup SSH for DAEMON user
mkdir $homedir/.ssh
echo $GIT_FINGERPRINT | base64 -d > $homedir/.ssh/known_hosts
echo $SSH_RSA_KEY | base64 -d > $homedir/.ssh/id_rsa 

# Permissions
chown daemon:root $homedir/.ssh -R
chmod 700 $homedir/.ssh -R
chmod 600 $homedir/.ssh/id_rsa


if [ ! -d "/bitnami/dokuwiki/data/docs" ]; then
    echo "DOKU_GITBACKED: Cloning GIT_REPO to /bitnami/dokuwiki/data/docs"
    sudo -u daemon git clone $GIT_REPO /bitnami/dokuwiki/data/docs

    echo "DOKU_GITBACKED: Setting GIT CONFIG local properties"
    cd /bitnami/dokuwiki/data/docs
    sudo -u daemon git config --local user.name dokuwiki
    sudo -u daemon git config --local user.email $DOKUWIKI_EMAIL
else
    echo "DOKU_GITBACKED: /bitnami/dokuwiki/data/docs already exists"
fi

echo "DOKU_GITBACKED: note - you may need to update DOKUWIKI global conf to use the directories within /bitnami/dokuwiki/data/docs"