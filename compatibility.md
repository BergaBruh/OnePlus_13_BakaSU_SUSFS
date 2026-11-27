# Compatibility of OnePlus Kernels
## OnePlus 13 Global source baseline

The current published Global build remains based on the matching official
OnePlusOSS **16.0.9.401(EX01)** source pair. Its selected config is
`configs/oos16/OP13-GLOBAL-6.6.118.json` with **Linux 6.6.118 / android15 KMI**.
The synchronization commits explicitly list CPH2649 and CPH2653; they do not
establish support for CPH2655 on this source release.

**ColorOS 17 / Android 17 for CPH2653 EU/GLO is the next target.** It is not
marked build-compatible merely because the firmware is available. A ColorOS 17
release requires matching official OnePlusOSS common-kernel and
modules/device-tree revisions for the same CPH2653 release, verification of the
actual KMI/Linux version, and a compatible BakaSU + SUSFS pair. As checked on
2026-11-03, that official CPH2653 17.x source pair is still missing, so the
existing OxygenOS kernel must not be relabeled as a ColorOS 17 build.

### ColorOS 17 OTA analysis (CPH2653_11.H.05_3050)

The full ColorOS 17 OTA for CPH2653 was analysed on 2026-11-03:

| Property | Value |
| --- | --- |
| Firmware | `CPH2653_11.H.05_3050`, V17.0.0, Android 17, security patch 2026-10-01 |
| OTA type | full, 54 partitions, no delta operations |
| Stock kernel | `6.6.118-android15-8-gc4127a25dcf3-ab15863337-4k` |
| Stock kernel source | `c4127a25dcf3` — **not published** by OnePlus or AOSP GKI |

The stock kernel runs **Linux 6.6.118** with the **android15-8** KMI, the same
baseline as the published OxygenOS 16 source pair. The exported symbol CRCs of
a 6.6.118 source-fallback build were compared against the stock kernel and are
identical for every symbol the shipped `vendor_dlkm` modules import.

So the ColorOS 17 firmware is **not** blocked on kernel ABI. The remaining
blocker is the unpublished kernel source, which is why the fallback build
stays an explicitly experimental compatibility test and is not published as a
ColorOS 17 release. A working LKM must be built against the OnePlus 6.6.118
tree; the generic upstream AOSP GKI 6.6.127 module that is commonly offered
cannot load on this device.

See [ColorOS 17 migration status](docs/op13-coloros17-migration.md) and the
[OxygenOS 16 source evidence](docs/op13-upstream-update.md).

## OnePlus Devices

<table>
  <tr>
    <th> :warning: </th>
    <th> All the Kernels are built on <a href="https://github.com/OnePlusOSS/">OnePlus Official Source</a> and are expected to work only on Stock roms!!!</th>
  </tr>
</table>

 - Currently All the kernels are built from Android 15 Manifest.
 - Do not use the zips after Major Android OTA (a15 -> a16) unless its verified in <a href="https://t.me/huangdihd_wildkernel">WildKernels</a> Telegram group or other sources like XDA.
