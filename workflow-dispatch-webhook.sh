#!/bin/bash
#
# Workflows can also be triggered via workflow_dispatch using webhooks. The advantage over repository dispatch is twofold:
#
# - First, we can target running workflow files on other branches.
# - Second, we can target specific workflows.
#
# Script usage:
# $ GITHUB_TOKEN=<TOKEN_HERE> sh workflow-dispatch-webhook.sh [branch_name]
#

TARGET_BRANCH="${1:-main}"

echo $TARGET_BRANCH

curl -L https://api.github.com/repos/jamesmortensen/repository-dispatch-demo/actions/workflows/second.yml/dispatches \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    --data '{"ref":"'"$TARGET_BRANCH"'","inputs":{"version":"1.2"}}'

# curl -L https://api.github.com/repos/jamesmortensen/repository-dispatch-demo/dispatches \
#     -X POST \
#     -H 'Accept: application/vnd.github.v3+json' \
#     -H "Authorization: token $GITHUB_TOKEN" \
#     --data '{"event_type":"build","client_payload":{"version":"1.1"}'

