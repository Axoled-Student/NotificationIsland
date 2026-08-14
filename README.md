# Notification Island

A minimal iOS 27 prototype that exposes a Shortcuts/App Intent action and starts a Live Activity showing two text fields in the Dynamic Island.

## What this version does

Shortcuts action:

**顯示 Dynamic Island 訊息**

Inputs:
- 標題
- 訊息

The intent conforms to `LiveActivityIntent`, so it can start a Live Activity from a system context. Apple documents this pattern for starting Live Activities from App Intents. 

## Important

This prototype is intentionally the first step. It does **not** yet read LINE notifications automatically.

After this is installed and tested, the next step is to connect the iOS 27 notification automation to the two Shortcuts inputs.

## Build without a Mac

The included GitHub Actions workflow uses a macOS runner with Xcode 27 and builds an unsigned `.ipa`. The IPA can then be imported into iLoader and signed for your iPhone.

You still need your own Apple signing/installation method for the final install.

## Targets

- `NotificationIsland`: iOS app + App Intents
- `NotificationIslandWidget`: Widget Extension + Live Activity

Minimum deployment target: iOS 27.0.

## Security

Do not put your Apple ID password or signing certificates into this repository. Keep signing secrets in GitHub Actions Secrets if you later add automatic signing.


### CI build fix
The workflow explicitly outputs processed Info.plist files as XML to avoid an Xcode AppIntents SSU training parser failure seen in CI.


## Photo storage
Photos selected in Shortcuts are stored in the shared App Group container and the Live Activity state contains only the filename.

App Group: `group.com.example.NotificationIsland`
