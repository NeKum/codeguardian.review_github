#!/bin/bash

URL="http://127.0.0.1/api/v1/review/github"

curl -X POST $URL \
-H "Content-Type: application/json" \
-d "{\"github_token\": \"$GITHUB_TOKEN\", \"github_event_path\": \"$GITHUB_EVENT_PATH\", \"key\": \"$API_KEY\"}"