#!/bin/bash

URL="https://api.codeguardian.tech/api/v1/review/github"
STATUS_URL="https://api.codeguardian.tech/api/v1/event/status"

EVENT_DATA=$(cat "$GITHUB_EVENT_PATH")

EVENT_DATA_ESCAPED=$(echo "$EVENT_DATA" | jq -Rsa .)

RESPONSE=$(curl -s -w "%{http_code}" -X PUT $URL \
-H "Content-Type: application/json" \
-d "{\"GITHUB_TOKEN\": \"$GITHUB_TOKEN\", \"GITHUB_EVENT_DATA\": $EVENT_DATA_ESCAPED, \"key\": \"$KEY\"}")

HTTP_CODE=${RESPONSE: -3}
RESPONSE_BODY=${RESPONSE:0:$((${#RESPONSE} - 3))}

if [ "$HTTP_CODE" -ne 200 ]; then
    echo "Error: API request failed with status code $HTTP_CODE"
    exit 1
fi

EVENT_ID=$(echo $RESPONSE_BODY | jq -r '.event_id')

while true; do
    STATUS_RESPONSE=$(curl -s -w "%{http_code}" -X POST $STATUS_URL \
    -H "Content-Type: application/json" \
    -d "{\"event_id\": $EVENT_ID, \"key\": \"$KEY\"}")

    STATUS_HTTP_CODE=${STATUS_RESPONSE: -3}
    STATUS_RESPONSE_BODY=${STATUS_RESPONSE:0:$((${#STATUS_RESPONSE} - 3))}

    if [ "$STATUS_HTTP_CODE" -ne 200 ]; then
        echo "Error: Status check request failed with status code $STATUS_HTTP_CODE"
        exit 1
    fi

    STATUS=$(echo $STATUS_RESPONSE_BODY | jq -r '.status')

    if [ "$STATUS" == "end" ]; then
        echo "Event processing finished."
        break
    fi

    echo "Event status: $STATUS. Checking again in 10 seconds."
    sleep 10
done