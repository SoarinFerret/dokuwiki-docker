ARG DOKUWIKI_VERSION=20200729

FROM bitnami/dokuwiki:${DOKUWIKI_VERSION}

USER 0
COPY ./gitbacked_setup.sh /

RUN install_packages git openssh-client && \
    #rm -r /var/lib/apt/lists /var/cache/apt/archives && \
    chmod +x /gitbacked_setup.sh && \
    #sed -i "/info \"\*\* Starting DokuWiki setup \*\*\"/a \ \ \ \ /gitbacked_setup.sh" /opt/bitnami/scripts/dokuwiki/entrypoint.sh
    # /opt/bitnami/scripts/dokuwiki/setup.sh
    sed -i "/\/opt\/bitnami\/scripts\/dokuwiki\/setup.sh/a \ \ \ \ /gitbacked_setup.sh" /opt/bitnami/scripts/dokuwiki/entrypoint.sh
RUN useradd -s /bin/sh -u 1001 -G 0 bitnami && mkdir -p /home/bitnami/.ssh && chmod 770 /home/bitnami/.ssh && chown 1001:0 /home/bitnami/.ssh -R

USER 1001

ENV SSH_RSA_KEY="" \
    GIT_URL="" \
    GIT_FINGERPRINT=""
