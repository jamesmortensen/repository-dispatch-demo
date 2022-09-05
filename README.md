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
