#!/bin/bash

set -e

BASE_URL="http://localhost:8000"

PASS=0
FAIL=0

print_pass() {
  echo "[PASS] $1"
  PASS=$((PASS+1))
}

print_fail() {
  echo "[FAIL] $1"
  FAIL=$((FAIL+1))
}

echo "Testing GET /health"
curl -f $BASE_URL/health >/dev/null && print_pass "/health OK" || exit 1

# Unique service name (fixes duplicate issue)
SERVICE_NAME="google-$RANDOM"

echo "Testing POST /services"
RESP=$(curl -s -w "\n%{http_code}" \
-X POST $BASE_URL/services \
-H "Content-Type: application/json" \
-d "{\"name\":\"$SERVICE_NAME\",\"url\":\"https://google.com\"}")

CODE=$(echo "$RESP" | tail -n1)

if [ "$CODE" = "200" ]; then
  print_pass "/services POST OK"
else
  print_fail "/services POST FAILED"
  exit 1
fi

echo "Testing duplicate POST /services"
DUP=$(curl -s -w "\n%{http_code}" \
-X POST $BASE_URL/services \
-H "Content-Type: application/json" \
-d "{\"name\":\"$SERVICE_NAME\",\"url\":\"https://google.com\"}")

DUP_CODE=$(echo "$DUP" | tail -n1)

if [ "$DUP_CODE" = "409" ]; then
  print_pass "Duplicate handled correctly"
else
  print_fail "Duplicate handling failed"
  exit 1
fi

echo "Testing GET /services"
curl -f $BASE_URL/services >/dev/null && print_pass "/services GET OK" || exit 1

echo "Testing POST /incidents"
curl -f -X POST $BASE_URL/incidents \
-H "Content-Type: application/json" \
-d '{"service_name":"test","title":"issue"}' >/dev/null && print_pass "/incidents POST OK" || exit 1

echo "Testing GET /incidents"
curl -f $BASE_URL/incidents >/dev/null && print_pass "/incidents GET OK" || exit 1

echo ""
echo "PASS: $PASS | FAIL: $FAIL"

exit 0
