# OnePlus 13 ColorOS 17 migration

Status checked: **2026-11-03**

Target device: **OnePlus 13 Global / CPH2653**
Target firmware family: **ColorOS 17**
Userspace generation: **Android 17**

## Current gate

ColorOS 17 firmware availability is not sufficient to publish a kernel build.
The release target remains blocked until OnePlus publishes a matching source
pair for the same CPH2653 17.x firmware release in both:

- `OnePlusOSS/android_kernel_common_oneplus_sm8750`
- `OnePlusOSS/android_kernel_modules_and_devicetree_oneplus_sm8750`

At the time of this check, no matching CPH2653 17.x synchronization commits
were found in those repositories. The last known-good official Global source
pair therefore remains OxygenOS 16.0.9.401(EX01):

| Source | Commit |
| --- | --- |
| Common kernel | `e1b346b6b4f4096eb342ae3684838a942fd6f6c4` |
| Modules/device tree | `d50b305f7da9e14715a25120a4ac7b1a4b8b97c3` |

That baseline is Linux **6.6.118** with **android15** KMI. It must not be
relabeled or released as a ColorOS 17 kernel merely because a ColorOS 17 OTA is
available.

## KMI and SUSFS policy

Firmware family, userspace Android generation, KMI Android generation, Linux
kernel version and SUSFS branch are independent inputs.

For example, if the official ColorOS 17 source still reports an
`android15-6.6` kernel baseline, the correct SUSFS family remains
`gki-android15-6.6`. The workflow derives the expected SUSFS branch from the
state file's actual KMI generation and Linux major/minor version instead of
assuming `android17` from ColorOS 17.

The first ColorOS 17 source publication must be inspected for:

1. the CPH2653 firmware release in both OnePlusOSS repositories;
2. matching common and modules/device-tree release revisions;
3. `VERSION`, `PATCHLEVEL` and `SUBLEVEL` in the kernel Makefile;
4. the Android/KMI branch from the released build configuration;
5. the resulting full KMI string;
6. BakaSU compatibility with that kernel;
7. a matching SUSFS branch and patch set.

## Pipeline preparation

The repository is prepared for a ColorOS target without activating an
unverified release:

- build input validation accepts `COS<major>` as well as `OOS<major>`;
- matrix path validation accepts `configs/coloros17/` and
  `manifests/coloros17/`;
- release metadata labels the firmware generically as OS rather than OxygenOS;
- SUSFS branch validation is derived from actual KMI/kernel state;
- the state file records ColorOS 17 / Android 17 as the requested next target.

No `configs/coloros17` file, manifest, or release matrix row is created until
the official CPH2653 source pair exists. This prevents an OxygenOS kernel from
being distributed under a ColorOS 17 label.

## Activation procedure

When the official source pair appears:

1. verify that common and modules/device-tree commits name the same CPH2653
   ColorOS 17 release;
2. inspect the source tree and determine Linux version, KMI generation and full
   KMI;
3. select and verify the matching SUSFS branch;
4. verify the current BakaSU revision against the actual kernel;
5. create the ColorOS 17 manifest with immutable official source SHAs;
6. create the matching `configs/coloros17` configuration with the actual
   kernel/KMI values;
7. add the ColorOS row to the build/release matrix and its contract tests;
8. update `.github/update-state/op13-upstreams.json` last;
9. merge only after the repository contracts pass; the state-file update on
   `main` then triggers the build/release workflow.

If any source pair is incomplete or requires unsafe manual patch conflict
resolution, keep the last known-good OxygenOS target active and report the
blocker instead of publishing a release.

## ColorOS 17 OTA analysis (CPH2653_11.H.05_3050)

Analyzed on **2026-11-03** from the full OTA `eca6af30e9254d609388ec807e51f22b`.

### Firmware identity

| Property | Value |
| --- | --- |
| Target version | `CPH2653_11.H.05_3050_202610210134` |
| ROM version | `V17.0.0` |
| Android version | 17 |
| Security patch | 2026-10-01 |
| `mainline_version` | 371559000 |
| OTA type | full (single `payload.bin`, 8.6 GB, 54 partitions, no delta ops) |

All delta operations are absent: every partition uses `REPLACE`,
`REPLACE_BZ`, `REPLACE_XZ` or `ZERO`, so the payload is self-sufficient and no
base images are required.

### Stock kernel identity

The `boot` partition is an Android boot image v4 (page size 4096) carrying the
GKI `Image`:

```
Linux version 6.6.118-android15-8-gc4127a25dcf3-ab15863337-4k (kleaf@build-host)
(Android (11368308, +pgo, +bolt, +lto, +mlgo, based on r510928) clang version 18.0.0)
#1 SMP PREEMPT Wed Jul 15 13:58:53 UTC 2026
```

| Property | Value |
| --- | --- |
| Linux | 6.6.118 |
| KMI generation | `android15-8` |
| `UTS_RELEASE` | `6.6.118-android15-8-gc4127a25dcf3-ab15863337-4k` |
| `vermagic` | `6.6.118-android15-8-gc4127a25dcf3-ab15863337-4k SMP preempt mod_unload modversions aarch64` |
| Build source commit | `c4127a25dcf3` (**not published**) |

The commit `c4127a25dcf3` is absent from `aosp-mirror/kernel_common` and from
`OnePlusOSS/android_kernel_common_oneplus_sm8750`, whose only SM8750 branches
are OxygenOS 15/16. **OnePlus has not published the ColorOS 17 kernel source.**

### vermagic is not enforced by version string on GKI

AOSP's `kernel/module/version.c` in the OnePlus 6.6.118 tree implements:

```c
/* First part is kernel version, which we ignore if module has crcs. */
int same_magic(const char *amagic, const char *bmagic, bool has_crcs)
{
	if (has_crcs) {
		amagic += strcspn(amagic, " ");
		bmagic += strcspn(bmagic, " ");
	}
	return strcmp(amagic, bmagic) == 0;
}
```

For modules that carry a CRC table only the flag part
(`SMP preempt mod_unload modversions aarch64`) is compared; the version string
is skipped. This is confirmed by the shipped firmware itself: the 464 modules in
`vendor_dlkm` carry two *different* vermagics,
`6.6.118-android15-8-o-4k` (253 modules) and
`6.6.118-android15-8-o-g1524d9b076be-4k` (211 modules), and neither equals the
running kernel's `6.6.118-android15-8-gc4127a25dcf3-ab15863337-4k`.

**Consequence:** a mismatching vermagic version string is *not* the reason a
module fails to load on this device. The gate is the per-symbol CRC check.

### Symbol CRC compatibility with the fallback kernel

The exported-symbol CRC table (`__kcrctab`) was extracted from the stock
ColorOS 17 `Image` and from the OOS16 source-fallback `Image`, and compared
against the 4341 distinct `(symbol, CRC)` pairs imported by the shipped
`vendor_dlkm` modules:

| Result | Count |
| --- | --- |
| CRC identical in stock and fallback kernel | 2685 |
| CRC present in stock but different in fallback | **0** |
| CRC not exported by the kernel (vendor-module exports, tracepoints) | 1656 |

The fallback kernel therefore exports the same CRCs as the stock ColorOS 17
kernel for every symbol the vendor modules need. The `android15-8` KMI
generation holds across the two builds.

### BakaSU/SUSFS pairing constraint

BakaSU and SUSFS implement `selinux_hide` in mutually exclusive ways:

| BakaSU | Expected SUSFS |
| --- | --- |
| `8450dd287ef6ee25ca2b6b858b43c9354c73060c` (UAPI 5) — declares the SELinux helpers as `extern` (`__maybe_static`) | `937215cb3a1b1f333d764c366c7a49972fa8e7a0` — renames the in-kernel helpers to the global `*_with_policy` variants |
| `516d3e87fbc986ccefdde2c2765f1700612441a9` (UAPI 6) — implements `selinux_hide` itself and keeps the helpers file-local | `c7f670f57b7d43d75066b6657f8aee9cdf580d96` — leaves the in-kernel helpers untouched and expects `ksu_selinux_hide_running` / `ksu_selinux_hide_enabled` from BakaSU |

Mixing the two directions fails at link time with
`undefined symbol: security_context_to_sid_with_policy`, because
`security/selinux/hooks.c` and `security/selinux/selinuxfs.c` call a global
symbol that BakaSU defines as `static`.

The ColorOS 17 experimental build therefore pins BakaSU UAPI 6 together with
SUSFS `c7f670f`. The OxygenOS builds keep the older, validated pairing. The
build action now fails fast with an explicit error when the pairing is wrong.

### Resulting decision

The ColorOS 17 OTA is **not** blocked on kernel ABI. Linux 6.6.118 and the
`android15-8` KMI generation are identical to the fallback baseline, and the
symbol CRCs match, so a fallback kernel can load the stock ColorOS 17
`vendor_dlkm` modules. The remaining blocker is the **unpublished kernel
source**: `c4127a25dcf3` cannot be rebuilt, so the fallback remains a
compatibility experiment rather than a ColorOS 17 release, and it must not be
relabelled as one.

