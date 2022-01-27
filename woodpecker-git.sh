#!/bin/sh

set -eu

git config --global user.email "${PLUGIN_AUTHOR_NAME}"
git config --global user.name "${PLUGIN_AUTHOR_EMAIL}"

if [ -n "${PLUGIN_GIT_REPLACE_WITH}" ] && [ -n "${PLUGIN_GIT_REPLACE_PREFIX}" ]; then
	git config --global url."${PLUGIN_GIT_REPLACE_WITH}".insteadOf "${PLUGIN_GIT_REPLACE_PREFIX}"
fi

mkdir -p ~/.ssh
case "${PLUGIN_SSH_ONLY_TRUST_DNS_KEYS}" in
	y|yes|true|Y|YES|TRUE|1)
		printf "Host *\n\tUpdateHostKeys yes\n\tStrictHostKeyChecking yes\n\tVerifyHostKeyDNS yes\n" > ~/.ssh/config
		;;
	*)
		printf "Host *\n\tUpdateHostKeys yes\n\tStrictHostKeyChecking no\n" > ~/.ssh/config
		;;
esac

eval $(ssh-agent -s | sed 's/^echo/#echo/')
case "${PLUGIN_SSH_DEPLOY_KEY}" in
	n|no|false|N|NO|FALSE|0|"")
		;;
	generate)
		if ! [ -f ~/.ssh/id_rsa ]; then
			echo "Generating an anonymous deploy key..." >&2
		        ssh-keygen -t rsa -f ~/.ssh/id_rsa -C "anonymous-deploy-key" -N "" >&2
		fi
		;;
	*)
		printenv PLUGIN_SSH_DEPLOY_KEY | ssh-add -
		;;
esac

if [ $# -gt 0 ]; then
	exec "$@"
elif [ -n "${PLUGIN_ACTION}" ]; then
	eval "${PLUGIN_ACTION}"
else
	exec /bin/ash
fi
