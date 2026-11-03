<div align="center">

# 🔥 BergaBruh's Fork of Wild Kernels for OnePlus 13

[![KernelSU](https://img.shields.io/badge/KernelSU-Supported-green)](https://kernelsu.org/)
[![ReSukiSU](https://img.shields.io/badge/ReSukiSU-Supported-green)](https://resukisu.github.io/)
[![SUSFS](https://img.shields.io/badge/SUSFS-Integrated-orange)](https://gitlab.com/simonpunk/susfs4ksu)
[![OnePlusOSS Tracking Status](https://img.shields.io/badge/OnePlusOSS--Tracker-active-green)](https://github.com/WildKernels/OnePlus_KernelSU_SUSFS/blob/status-page/README.md)

</div>

## ⚠️ Disclaimer

Flashing this kernel will not void your warranty, but there is always a risk of bricking your device. Please make sure to:
- 💾 Back up your data
- 🧠 Understand the risks before proceeding

- I am **not responsible** for bricked devices, damaged hardware, or any issues that arise from using this kernel.

- **Please** do thorough research and fully understand the features added in this kernel before flashing it!

- By flashing this kernel, **YOU** are choosing to make these modifications. If something goes wrong, **do not blame me**!

<div align="center">
  
# **🚨 Proceed at your own risk!**

</div>

## OnePlus 13: current and next source targets

**Active release baseline:** the latest matching official OnePlusOSS pair for
OnePlus 13 Global/CPH2653 remains **OxygenOS 16.0.9.401(EX01)** with
**Linux 6.6.118 / android15 KMI**. The newer OxygenOS 16.0.10.600 firmware did
not receive a matching public source publication when last checked.

**Next target:** **ColorOS 17 / Android 17 for CPH2653 EU/GLO**. Firmware
availability does not by itself prove that matching kernel sources have been
published. As checked on **2026-11-03**, the OnePlusOSS SM8750 common-kernel and
modules/device-tree repositories do not expose a matching CPH2653 17.x source
pair, so no ColorOS 17 release ZIP is published from an OxygenOS source fallback.

The build pipeline is prepared to accept `COS17`, `configs/coloros17` and
`manifests/coloros17`. SUSFS branch selection is derived from the actual
kernel KMI generation and Linux major/minor version rather than from the
userspace Android version. Activation remains gated on matching official source
SHAs. See the [ColorOS 17 migration notes](docs/op13-coloros17-migration.md).

ReSukiSU now lives at **Baka-SU/BakaSU**. The last validated release baseline
pins BakaSU `8450dd287ef6ee25ca2b6b858b43c9354c73060c` and **SUSFS v2.3.0**
`937215cb3a1b1f333d764c366c7a49972fa8e7a0` from `gki-android15-6.6`.
All six baseline kernel builds passed in
[run 37908077540](https://github.com/BergaBruh/OnePlus_13_ReSukiSU_SUSFS/actions/runs/37908077540).

If the SUSFS module displays **Unsupported Kernel** or **SUS PATH UNDEFINED**,
follow the [helper diagnosis and repair instructions](docs/susfs-unsupported-kernel.md).

## 🔧 Available Kernels

<div align="center">

| Kernel | Repository | Status |
|--------|------------|--------|
| 📱 **OnePlus/Oppo/Realme** | [OnePlus_KernelSU_SUSFS](https://github.com/WildKernels/OnePlus_KernelSU_SUSFS) | ✅ Active |
</div>

## 🔗 Additional Resources

- 🩹 [Kernel Patches](https://github.com/WildKernels/kernel_patches)
- ⚡ [Kernel Flasher](https://github.com/fatalcoder524/KernelFlasher)

## 📱 Device Compatibility

- Please verify the device compatibility before flashing here: [Compatibility_Info](https://github.com/WildKernels/OnePlus_KernelSU_SUSFS/blob/main/compatibility.md). 

## 📱 OnePlusOSS Repositories Tracking

- 📊 **Live Dashboard**: [OnePlus Repos Tracking & Changes](https://github.com/WildKernels/OnePlus_KernelSU_SUSFS/blob/status-page/README.md)
- ⏱️ **Update Frequency**: Every 2 hours (Automated)

## ✨ Features

- 🔐 **ReSukiSU**: Kernel-based Android Root Solution,forked from SukiSU
- 🥷 **SUSFS**: An addon root hiding kernel patches and userspace module for KernelSU-based
- 🛡️ **BBG**: LSM-based Baseband Guard security to protect critical device partitions. abl/efisp can be added to whitelist for efisp exploit devices.
- 🛠️ **HMBIRD SCX**: Scheduler extensions for SM8750 devices
- 🖧 **BBRv1**: Improved TCP congestion control
- 🖧 **BBRv3**: Improved TCP congestion control
- 🚦 **CAKE and PIE qdisc Support**: Better Net Schedulers
- ✅ **LTO**: Link Time Optimisation enabled
- 🚀 **Optimisation patches**: Memory, I/O, CPU scheduler, network and other general tunings
- 🌐 **TTL Target Support**: Network packet manipulation
- 🧱 **IP Set & IPv6 NAT Support**: Advanced firewall capabilities and IPv6 NAT Support
- ⚡️ **TMPFS XATTR / POSIX ACL**: Extended TMPFS support for meta modules and Mountify
- </> **Unicode Bypass Fix**: Prevent path traversal and other detections using non-printable Unicode codepoints [Experimental]
- 🖥️ **Droidspaces Support**: Support Portable Linux containers with namespaces to run full Linux environments.
- 🔃 **NTSync**: Provide high-performance, low-latency synchronization primitives compatible with the Windows NT kernel API

## 📋 Installation Instructions

- **KernelSU**: Developed by [tiann](https://github.com/tiann/KernelSU).
- **ReSukiSU**: Developed by [ReSukiSU Team](https://github.com/Baka-SU/BakaSU)
- **Magic-KSU**: Developed by [5ec1cff](https://github.com/5ec1cff/KernelSU).  
- **SUSFS**: Developed by [simonpunk](https://gitlab.com/simonpunk/susfs4ksu.git).
- **SUSFS Module**: Developed by [sidex15](https://github.com/sidex15).
- **Sultan Kernels**: Developed by [kerneltoast](https://github.com/kerneltoast).
For GKI installation, please follow the official guide:

📖 **[KernelSU Installation Guide](https://kernelsu.org/guide/installation.html)**

You can also find Installation instructions in the release notes.

## 🌟 Special Thanks

**These amazing people help make this project possible! ❤️**

<div align="center">


| 🔧 **Project** | 👨‍💻 **Developer** | 🔗 **Link** |
|:---------------:|:----------------:|:-----------:|
| **KernelSU** | tiann | [![GitHub](https://img.shields.io/badge/GitHub-tiann-blue?style=flat-square&logo=github)](https://github.com/tiann/KernelSU) |
| **ReSukiSU** | resukisu | [![GitHub](https://img.shields.io/badge/GitHub-resukisu-blue?style=flat-square&logo=github)](https://github.com/Baka-SU/BakaSU) |
| **Magic-KSU** | 5ec1cff | [![GitHub](https://img.shields.io/badge/GitHub-5ec1cff-blue?style=flat-square&logo=github)](https://github.com/5ec1cff/KernelSU) |
| **SUSFS** | simonpunk | [![GitLab](https://img.shields.io/badge/GitLab-simonpunk-orange?style=flat-square&logo=gitlab)](https://gitlab.com/simonpunk/susfs4ksu.git) |
| **SUSFS Module** | sidex15 | [![GitHub](https://img.shields.io/badge/GitHub-sidex15-blue?style=flat-square&logo=github)](https://github.com/sidex15) |
| **Sultan Kernels** | kerneltoast | [![GitHub](https://img.shields.io/badge/GitHub-kerneltoast-blue?style=flat-square&logo=github)](https://github.com/kerneltoast) |
| **Baseband Guard** | vc-teahouse | [![GitHub](https://img.shields.io/badge/GitHub-vc--teahouse-blue?style=flat-square&logo=github)](https://github.com/vc-teahouse/Baseband-guard.git) |
| **Droidspaces** | ravindu644 | [![GitHub](https://img.shields.io/badge/GitHub-ravindu644-blue?style=flat-square&logo=github)](https://github.com/ravindu644/Droidspaces-OSS.git) |

</div>

*If you have contributed and are not listed here, please remind me!* 🙏

## 💬 Support

If you encounter any issues or need help, feel free to:
- 🐛 Open an issue in this repository
- 💬 Reach out to me directly
