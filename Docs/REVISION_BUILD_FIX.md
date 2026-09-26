# Revision: iOS target + GitHub Actions build fix

The first GitHub Actions run failed because the generated Xcode target did not explicitly declare iOS SDK/platform settings, so xcodebuild exposed only macOS destinations.

This revision:
- sets `SDKROOT = iphoneos`
- sets `SUPPORTED_PLATFORMS = iphoneos iphonesimulator`
- disables Mac Catalyst
- adds a shared Xcode scheme
- uses `xcodebuild archive` against the generic iOS destination
- explicitly selects the iPhoneOS SDK
- uploads the unsigned `.xcarchive` as the first build artifact

Do not change the workflow to an iOS Simulator destination for archive builds. An archive intended for iPhone should use `generic/platform=iOS`.
