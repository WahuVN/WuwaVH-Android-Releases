# WuWa Việt Hoá — Android Releases

This is a **release-only** channel for the Android app. Source code stays in the private development repository. Do not upload source trees, secrets, development logs, signing keystores, or game client files.

**Current status: PUBLIC RELEASE-ONLY UPDATE CHANNEL.**

## Android updater contract
- The app polls `https://api.github.com/repos/WahuVN/WuwaVH-Android-Releases/releases?per_page=20` when Home is opened.
- GitHub tag format: `android-alpha.27` for Android `0.2.0-alpha.27` (versionCode 27).
- Asset name: `WuWa-Viet-Hoa-Android-v0.2.0-alpha.27.apk`.
- Upload only an APK signed with the *same trusted Android certificate* as the previous app version; Android requires user approval for installation.
- Publish only QA-approved APKs. This repository stays **public** so installed apps can check updates without credentials; the source repository remains separate/private.
- GitHub's release asset `digest: sha256:...` is checked against downloaded APK bytes. The Android app additionally checks package name, versionCode and signing key before handing the APK to Android's package installer.
- Game payload writes remain separate from app self-update: they require Shizuku/write access, a real game SIG, payload hash verification and transactional rollback; game/resource version metadata does not block installation.

## Planned QA acceptance
1. Verify repository API publicly returns HTTP 200 and a list of releases.
2. Publish a verified version with versionCode above installed. Check the Android app displays tag and size, changelog, allows download.
3. Download, verify SHA-256 and signing certificate, then confirm Android installer prompts to update.
4. Negative cases: stale version, missing digest, wrong APK package, wrong certificate, bad SHA, offline, cancel installation.
5. Alpha prereleases may use the established alpha signer; never present a debug-signed alpha as the stable production channel.

## Release checklist
See `RELEASE_CHECKLIST.md`. All release changes require actual signed APK and runtime evidence.
