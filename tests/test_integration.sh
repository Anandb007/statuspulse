#!/bin/bash

set -e

BASE_URL="http://localhost:8000"

PASS_COUNT=0
FAIL_COUNT=0

print_pass() {
    echo "[PASS] $1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

print_fail() {
    echo "[FAIL] $1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

# ==========================================
# Test Health Endpoint
# ==========================================

echo "Testing GET /health"

HEALTH_RESPONSE=$(curl -s -w "\n%{http_code}" $BASE_URL/health)

HEALTH_BODY=$(echo "$HEALTH_RESPONSE" | head -n1)
HEALTH_CODE=$(echo "$HEALTH_RESPONSE" | tail -n1)

if [ "$HEALTH_CODE" = "200" ]; then
    echo "$HEALTH_BODY" | jq . >/dev/null 2>&1
    print_pass "/health returned HTTP 200 with valid JSON"
else
    print_fail "/health failed"
    exit 1
fi

# ==========================================
# Test POST /services
# ==========================================

echo "Testing POST /services"

SERVICE_RESPONSE=$(curl -s -w "\n%{http_code}" \
-X POST $BASE_URL/services \
-H "Content-Type: application/json" \
-d '{
  "name":"google",
  "url":"https://google.com"
}')

SERVICE_BODY=$(echo "$SERVICE_RESPONSE" | head -n1)
SERVICE_CODE=$(echo "$SERVICE_RESPONSE" | tail -n1)

if [ "$SERVICE_CODE" = "200" ]; then
    echo "$SERVICE_BODY" | jq . >/dev/null 2>&1
    print_pass "/services POST succeeded"
else
    print_fail "/services POST failed"
    exit 1
fi

# ==========================================
# Duplicate Service Test
# ==========================================

echo "Testing duplicate POST /services"

DUPLICATE_RESPONSE=$(curl -s -w "\n%{http_code}" \
-X POST $BASE_URL/services \
-H "Content-Type: application/json" \
-d '{
  "name":"google",
  "url":"https://google.com"
}')

DUPLICATE_CODE=$(echo "$DUPLICATE_RESPONSE" | tail -n1)

if [ "$DUPLICATE_CODE" = "409" ]; then
    print_pass "Duplicate service correctly returned 409"
else
    print_fail "Duplicate service validation failed"
    exit 1
fi

# ==========================================
# Test GET /services
# ==========================================

echo "Testing GET /services"

GET_SERVICES=$(curl -s -w "\n%{http_code}" $BASE_URL/services)

GET_SERVICES_BODY=$(echo "$GET_SERVICES" | head -n1)
GET_SERVICES_CODE=$(echo "$GET_SERVICES" | tail -n1)

if [ "$GET_SERVICES_CODE" = "200" ]; then
    echo "$GET_SERVICES_BODY" | jq . >/dev/null 2>&1
    print_pass "/services GET succeeded"
else
    print_fail "/services GET failed"
    exit 1
fi

# ==========================================
# Test POST /incidents
# ==========================================

echo "Testing POST /incidents"

INCIDENT_RESPONSE=$(curl -s -w "\n%{http_code}" \
-X POST $BASE_URL/incidents \
-H "Content-Type: application/json" \
-d '{
  "service_name":"google",
  "title":"API latency issue",
  "description":"Latency spike detected",
  "severity":"major"
}')

INCIDENT_BODY=$(echo "$INCIDENT_RESPONSE" | head -n1)
INCIDENT_CODE=$(echo "$INCIDENT_RESPONSE" | tail -n1)

if [ "$INCIDENT_CODE" = "200" ]; then
    echo "$INCIDENT_BODY" | jq . >/dev/null 2>&1
    print_pass "/incidents POST succeeded"
else
    print_fail "/incidents POST failed"
    exit 1
fi

# ==========================================
# Test GET /incidents
# ==========================================

echo "Testing GET /incidents"

GET_INCIDENTS=$(curl -s -w "\n%{http_code}" $BASE_URL/incidents)

GET_INCIDENTS_BODY=$(echo "$GET_INCIDENTS" | head -n1)
GET_INCIDENTS_CODE=$(echo "$GET_INCIDENTS" | tail -n1)

if [ "$GET_INCIDENTS_CODE" = "200" ]; then
    echo "$GET_INCIDENTS_BODY" | jq . >/dev/null 2>&1
    print_pass "/incidents GET succeeded"
else
    print_fail "/incidents GET failed"
    exit 1
fi

# ==========================================
# Final Summary
# ==========================================

echo ""
echo "=========================================="
echo "Integration Test Summary"
echo "=========================================="

echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo "All integration tests passed."
    exit 0
else
    echo "Some integration tests failed."
    exit 1
fi
