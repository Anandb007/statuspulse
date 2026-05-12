#!/bin/bash

TOPIC="statuspulse-alerts"

MESSAGE=$1

curl -d "$MESSAGE" https://ntfy.sh/$TOPIC
