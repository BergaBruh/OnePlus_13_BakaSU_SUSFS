# OnePlus 13: official source research (2026-11-27)

## Official repositories and branches

The OnePlusOSS [OnePlus 13 manifest](https://raw.githubusercontent.com/OnePlusOSS/kernel_manifest/oneplus/sm8750/oneplus_13.xml) on manifest branch `oneplus/sm8750` selects three different repositories, all at `oneplus/sm8750_v_15.0.0_oneplus_13`: [common kernel](https://github.com/OnePlusOSS/android_kernel_common_oneplus_sm8750), [vendor kernel](https://github.com/OnePlusOSS/android_kernel_oneplus_sm8750), and [modules and device tree](https://github.com/OnePlusOSS/android_kernel_modules_and_devicetree_oneplus_sm8750). Other dependencies in the manifest come from CodeLinaro at pinned revisions. This is the manifest for that named branch, not proof that no newer sources exist.

The local `docs/op13-upstream-update.md` records the `oneplus/sm8750_b_16.0.0_oneplus_13` source line and identifies three commits: common [`e1b346b6b4f4096eb342ae3684838a942fd6f6c4`](https://github.com/OnePlusOSS/android_kernel_common_oneplus_sm8750/commit/e1b346b6b4f4096eb342ae3684838a942fd6f6c4), vendor [`6028f47faddaa27700f8dd3a1d83906ea8f27170`](https://github.com/OnePlusOSS/android_kernel_oneplus_sm8750/commit/6028f47faddaa27700f8dd3a1d83906ea8f27170), modules [`d50b305f7da9e14715a25120a4ac7b1a4b8b97c3`](https://github.com/OnePlusOSS/android_kernel_modules_and_devicetree_oneplus_sm8750/commit/d50b305f7da9e14715a25120a4ac7b1a4b8b97c3). The modules commit page was independently retrieved and explicitly identifies `CPH2653_16.0.9.401(EX01)`, `CPH2649_16.0.9.401(EX01)` and `PJZ110_16.0.9.401(CN01)` in its message. The other two commit pages could not be independently retrieved in this session; the local evidence is not a fresh check of their current branch heads.

## Comparison with local project

The local `manifests/oos16/oneplus_13_global_6.6.118_w.xml` pins the common and modules commits above, not the vendor kernel. The experimental `manifests/coloros17/oneplus_13_global_cos17_source_fallback_6.6.118.xml` explicitly uses the same OxygenOS 16 pair as a source fallback; this is not an official ColorOS 17 source release. The local migration analysis dated 2026-11-03 reports OTA `CPH2653_11.H.05_3050_202610210134`, Android 17 userspace, and kernel `6.6.118-android15-8-gc4127a25dcf3-ab15863337-4k`. These are local analysis claims, not independently re-examined OTA evidence. Android userspace version does not by itself determine the kernel KMI generation.

On 2026-11-23 a user opened [OnePlusOSS issue #233](https://github.com/OnePlusOSS/kernel_manifest/issues/233), requesting sources synchronized with `CPH2653_17.0.0.102(EX01)`; on retrieval the issue was open with no activity shown. This is a community request, not a OnePlus statement that sources do or do not exist. No matching official ColorOS 17 source pair was verified in this research.

## Coverage limitation

Remote `git ls-remote` failed with `schannel: AcquireCredentialsHandle failed: SEC_E_NO_CREDENTIALS (0x8009030e)`; GitHub API requests through the available web fetch were rejected. Thus a complete current branch inventory, branch tip SHAs and commit dates could not be verified. Do not interpret this as proof of absence of newer OnePlus 13 source branches or of compatibility with newer firmware.
