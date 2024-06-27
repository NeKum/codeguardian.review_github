#!/bin/bash

URL="http://api.codeguardian.tech:8084/api/v1/review/github"

curl -X PUT $URL \
-H "Content-Type: application/json" \
-d "{\"GITHUB_TOKEN\": \"$GITHUB_TOKEN\", \"GITHUB_EVENT_PATH\": \"$GITHUB_EVENT_PATH\", \"key\": \"$KEY\"}"