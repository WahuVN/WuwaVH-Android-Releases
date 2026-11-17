# Android Release QA checklist

- [ ] APK compiled and full unit/instrumentation checks passed
- [ ] Font and translation packs checked for correct SHA and language glyph coverage
- [ ] Installed on actual Android device; no crash, version and Shizuku preferences preserved
- [ ] Font apply/revert and translation text verified inside the real game
- [ ] Stable/production channel only: APK signed with the dedicated production certificate
- [ ] Upgrading from the previous build in the same channel succeeds because signer matches
- [ ] Public alpha APK is a release build: non-debuggable and contains no DebugInstallReceiver/DEBUG broadcast QA hooks
- [ ] GitHub Release tag follows android-alpha.N, APK filename includes alpha.N
- [ ] Release asset SHA-256 provided by GitHub digest, and verified
- [ ] Public release channel approved and made public; main/source GitHub repo stays private
- [ ] GitHub API read without credentials tested
- [ ] Release notes include changes, compatibility and install instructions

Publishing a release is a separate, externally visible action. Never publish before approval.
