FROM bitnami/dokuwiki:latest

COPY ./gitbacked_setup.sh /

RUN install_packages git openssh-client && \
    chmod +x /gitbacked_setup.sh && \
    sed -i "/info \"Starting dokuwiki... \"/a \ \ /gitbacked_setup.sh" /app-entrypoint.sh

ENV SSH_RSA_KEY="" \
    GIT_URL="" \
    GIT_FINGERPRINT=""
