#!/bin/bash
# Extract Burp Suite CA certificate for browser trust
set -e

BURP_JAR=$(find /usr/lib -name "burpsuite_community.jar" -o -name "burpsuite_pro.jar" 2>/dev/null | head -1)
JAVA_BIN=$(find /usr/lib/jvm -name "java" -path "*/bin/java" 2>/dev/null | sort -V | tail -1)

if [[ -z "$BURP_JAR" || -z "$JAVA_BIN" ]]; then
    echo "Error: Burp Suite or Java not found" >&2
    exit 1
fi

echo "Starting Burp Suite headlessly..."
"$JAVA_BIN" -Djava.awt.headless=true -jar "$BURP_JAR" &
BURP_PID=$!
sleep 30

echo "Downloading CA certificate..."
curl -so /tmp/cacert.der http://localhost:8080/cert

kill "$BURP_PID" 2>/dev/null || true

if [[ -f /tmp/cacert.der ]]; then
    cp /tmp/cacert.der /usr/local/share/ca-certificates/BurpSuiteCA.der
    update-ca-certificates
    echo "Burp CA certificate installed"
else
    echo "Error: Failed to download certificate" >&2
    exit 1
fi
