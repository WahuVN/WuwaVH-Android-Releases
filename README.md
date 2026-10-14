# WuWa Việt Hoá — Android Releases

This is a **release-only** channel for the Android app. Source code stays in the private development repository. Do not upload source trees, secrets, development logs, signing keystores, or game client files.

**Current status: PRIVATE STAGING / not published.**

## Android updater contract
- The app polls `https://api.github.com/repos/WahuVN/WuwaVH-Android-Releases/releases?per_page=20` when Home is opened.
- GitHub tag format: `android-alpha.17` for Android `0.2.0-alpha.17` (versionCode 17).
- Asset name: `WuWa-Viet-Hoa-Android-v0.2.0-alpha.17.apk`.
- Upload only an APK signed with the *same trusted Android certificate* as the previous app version; Android requires user approval for installation.
- Publish an APK via GitHub Releases only after QA and explicit owner approval. The repository must become **public** before users without access can check updates.
- GitHub's release asset `digest: sha256:...` is checked against downloaded APK bytes. The Android app additionally checks package name, versionCode and signing key before handing the APK to Android's package installer.
- Never silently overwrite game PAKs: translation/font payloads require a separately verified signed content manifest and compatibility check.

## Planned QA acceptance
1. Verify repository API publicly returns HTTP 200 and a list of releases.
2. Publish a verified version with versionCode above installed. Check the Android app displays tag and size, changelog, allows download.
3. Download, verify SHA-256 and signing certificate, then confirm Android installer prompts to update.
4. Negative cases: stale version, missing digest, wrong APK package, wrong certificate, bad SHA, offline, cancel installation.
5. Never publish QA Debug builds as official production releases.

## Release checklist
See `RELEASE_CHECKLIST.md`. All release changes require actual signed APK and runtime evidence.
