# repository-dispatch-demo

Trigger the workflow with the following curl command:

```
$ curl -L https://api.github.com/repos/jamesmortensen/repository-dispatch-demo/dispatches \
    -X POST \
    -H 'accept: application/vnd.github.v3+json' \
    -H "Authorization: token $GITHUB_TOKEN" \
    --data '{"event_type":"build","client_payload":{"version":"1.1"}'
```

Note that a GITHUB_TOKEN, either a GitHub App Installation token or a personal access token, is required in the Authorization header.

And if sending dynamic data with variable expansion, either use double quotes, or end the single quotes and reopen them:

```
$ curl -L https://api.github.com/repos/jamesmortensen/repository-dispatch-demo/dispatches \
    -X POST \
    -H 'accept: application/vnd.github.v3+json' \
    -H "Authorization: token $GITHUB_TOKEN" \
    --data '{"event_type":"test","client_payload":{"version":"'$VM_VERSION'"}'
```

It's also possible to send files, if the action workflow contains handlers to base64 decode it:

```
$ tar cvfz connect.tar.gz connect-*. # create archive of files starting with connect-
$ curl -L https://api.github.com/repos/jamesmortensen/repository-dispatch-demo/dispatches \
    -X POST \
    -H 'accept: application/vnd.github.v3+json' \
    -H "Authorization: token $GITHUB_TOKEN" \
    --data '{"event_type":"file-test","client_payload":{"version":"1.1","base64_file_contents":"'$(base64 connect.tar.gz)'"}'
```

```
env:
  BASE64_FILE_CONTENTS: ${{ github.event.client_payload.base64_file_contents }}
steps:
- name: Extract client payload tarball
  if: ${{ github.event_name == 'repository_dispatch' }}
  run: |
    mkdir tmp && cd tmp
    echo $BASE64_FILE_CONTENTS > connect.tar.gz.base64
    base64 -d connect.tar.gz.base64 > connect.tar.gz
    tar xvfz connect.tar.gz
    ls -ltrSha
```

# workflow-dispatch-webhook

Note that it's also possible to trigger a workflow prorgammatically using curl, via the REST API and to trigger workflow_dispatch events. The advantages are as follows:

- We can trigger individual workflows.
- We can target workflows to run on specific branches with specific workflow files on that branch.

The below command triggers a workflow to run in second.yml and on the `wd-branch-demo` branch:

```
$ TARGET_BRANCH=wd-branch-demo curl -L https://api.github.com/repos/jamesmortensen/repository-dispatch-demo/actions/workflows/second.yml/dispatches \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    --data '{"ref":"'"$TARGET_BRANCH"'","inputs":{"version":"1.2"}}'
```

