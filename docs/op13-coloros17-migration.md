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
