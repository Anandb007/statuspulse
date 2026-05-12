#!/bin/bash

TOPIC="statuspulse-alerts-anand"
URL="https://ntfy.sh/$TOPIC"

MESSAGE="$1"

curl -d "$MESSAGE" $URL
