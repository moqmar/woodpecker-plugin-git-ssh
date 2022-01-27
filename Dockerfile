FROM alpine

RUN apk add --no-cache git openssh-client

ENV PLUGIN_AUTHOR_NAME="Woodpecker CI"
ENV PLUGIN_AUTHOR_EMAIL="git@woodpecker-ci.org"
ENV PLUGIN_GIT_REPLACE_PREFIX="https://"
ENV PLUGIN_GIT_REPLACE_WITH="ssh://git@"
ENV PLUGIN_SSH_DEPLOY_KEY="generate"
ENV PLUGIN_SSH_ONLY_TRUST_DNS_KEYS="false"
ENV PLUGIN_ACTION=""

COPY woodpecker-git.sh /usr/bin/
ENTRYPOINT ["/usr/bin/woodpecker-git.sh"]
