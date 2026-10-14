# Android Release QA checklist

- [ ] APK compiled and full unit/instrumentation checks passed
- [ ] Font and translation packs checked for correct SHA and language glyph coverage
- [ ] Installed on actual Android device; no crash, version and Shizuku preferences preserved
- [ ] Font apply/revert and translation text verified inside the real game
- [ ] Production APK signed with a dedicated securely retained signing certificate
- [ ] Upgrading from older APK succeeds because signer matches
- [ ] GitHub Release tag follows android-alpha.N, APK filename includes alpha.N
- [ ] Release asset SHA-256 provided by GitHub digest, and verified
- [ ] Public release channel approved and made public; main/source GitHub repo stays private
- [ ] GitHub API read without credentials tested
- [ ] Release notes include changes, compatibility and install instructions

Publishing a release is a separate, externally visible action. Never publish before approval.
