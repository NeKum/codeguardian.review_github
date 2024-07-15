#!/bin/bash

URL="https://api.codeguardian.tech/api/v1/review/github"

curl -X PUT $URL \
-H "Content-Type: application/json" \
-d "{\"GITHUB_TOKEN\": \"$GITHUB_TOKEN\", \"GITHUB_EVENT_DATA\": \"$EVENT_DATA\", \"key\": \"$KEY\"}"