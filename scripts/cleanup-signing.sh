#!/bin/bash
set +e
KEYCHAIN_PATH="$RUNNER_TEMP/app-signing.keychain-db"
security delete-keychain "$KEYCHAIN_PATH" 2>/dev/null || true
rm -f "$RUNNER_TEMP/signing.p12" "$RUNNER_TEMP/profile.mobileprovision"
rm -f "$HOME/Library/MobileDevice/Provisioning Profiles/profile.mobileprovision"
