#!/bin/bash
set -euo pipefail

: "${CERTIFICATE_BASE64:?Missing IOS_CERTIFICATE_BASE64}"
: "${CERTIFICATE_PASSWORD:?Missing IOS_CERTIFICATE_PASSWORD}"
: "${PROVISIONING_PROFILE_BASE64:?Missing IOS_PROVISIONING_PROFILE_BASE64}"
: "${KEYCHAIN_PASSWORD:?Missing IOS_KEYCHAIN_PASSWORD}"

CERT_PATH="$RUNNER_TEMP/signing.p12"
PP_PATH="$RUNNER_TEMP/profile.mobileprovision"
KEYCHAIN_PATH="$RUNNER_TEMP/app-signing.keychain-db"

printf '%s' "$CERTIFICATE_BASE64" | base64 --decode > "$CERT_PATH"
printf '%s' "$PROVISIONING_PROFILE_BASE64" | base64 --decode > "$PP_PATH"

security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
security set-keychain-settings -lut 21600 "$KEYCHAIN_PATH"
security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
security import "$CERT_PATH" -P "$CERTIFICATE_PASSWORD" -A -t cert -f pkcs12 -k "$KEYCHAIN_PATH"
security list-keychain -d user -s "$KEYCHAIN_PATH"
security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"

mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
cp "$PP_PATH" "$HOME/Library/MobileDevice/Provisioning Profiles/$(basename "$PP_PATH")"

security find-identity -v -p codesigning "$KEYCHAIN_PATH"
