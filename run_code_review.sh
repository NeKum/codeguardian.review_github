#!/bin/bash

URL="https://api.codeguardian.tech/api/v1/review/github"

# Чтение содержимого файла в переменную
EVENT_DATA=$(cat "$GITHUB_EVENT_PATH")

# Экранирование переменной для использования в JSON
EVENT_DATA_ESCAPED=$(echo "$EVENT_DATA" | jq -Rsa .)

# Отправка данных в API
curl -X PUT $URL \
-H "Content-Type: application/json" \
-d "{\"GITHUB_TOKEN\": \"$GITHUB_TOKEN\", \"GITHUB_EVENT_DATA\": $EVENT_DATA_ESCAPED, \"key\": \"$KEY\"}"

sleep 300