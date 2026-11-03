#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

python3 - "$repo_root" <<'PY'
import json
from pathlib import Path
import sys
import xml.etree.ElementTree as ET

root = Path(sys.argv[1])
state_path = root / ".github/update-state/op13-experimental-coloros17-source-fallback.json"
config_path = root / "configs/coloros17/OP13-GLOBAL-EXPERIMENTAL-6.6.118.json"
manifest_path = root / "manifests/coloros17/oneplus_13_global_cos17_source_fallback_6.6.118.xml"
workflow_path = root / ".github/workflows/build-op13-experimental-coloros17.yml"

for path in (state_path, config_path, manifest_path, workflow_path):
    if not path.is_file():
        raise SystemExit(f"missing experimental COS17 input: {path.relative_to(root)}")

state = json.loads(state_path.read_text())
config = json.loads(config_path.read_text())
workflow = workflow_path.read_text()

validation = state.get("validation", {})
if validation != {
    "experimental": True,
    "supported": False,
    "publish_release": False,
    "flash_permitted": True,
    "requires_recovery_plan": True,
}:
    raise SystemExit("unexpected experimental COS17 validation policy")

target = state.get("target", {})
expected_target = {
    "firmware_family": "ColorOS",
    "userspace_android_version": "android17",
    "source_firmware_family": "OxygenOS",
    "source_firmware_version": "16.0.9.401(EX01)",
    "source_fallback": True,
    "kernel_kmi_android_generation": "android15",
    "linux_kernel_version": "6.6.118",
    "config": "configs/coloros17/OP13-GLOBAL-EXPERIMENTAL-6.6.118.json",
    "manifest": "manifests/coloros17/oneplus_13_global_cos17_source_fallback_6.6.118.xml",
}
for key, value in expected_target.items():
    if target.get(key) != value:
        raise SystemExit(f"experimental COS17 state mismatch for {key}: {target.get(key)!r}")

if config.get("os_version") != "COS17":
    raise SystemExit("experimental config must identify COS17 userspace target")
if config.get("android_version") != "android15" or config.get("kernel_version") != "6.6":
    raise SystemExit("experimental config must retain the actual android15 / Linux 6.6 kernel baseline")
if config.get("manifest") != manifest_path.name:
    raise SystemExit("experimental config must reference the dedicated fallback manifest")
if config.get("uname") != "OP13-COS17-FALLBACK-RESUKISU":
    raise SystemExit("experimental uname must visibly identify the COS17 fallback build")
if config.get("susfs") is not True or config.get("custom_patches") is not True:
    raise SystemExit("experimental build must preserve SUSFS and the OP13 patch feature set")

if state.get("target", {}).get("kernel_driver_uapi_version") != 6:
    raise SystemExit("COS17 test build must target BakaSU UAPI 6")

sources = state.get("sources", {})
expected_sources = {
    "kernel_common": "e1b346b6b4f4096eb342ae3684838a942fd6f6c4",
    "kernel_modules": "d50b305f7da9e14715a25120a4ac7b1a4b8b97c3",
    "resukisu": "516d3e87fbc986ccefdde2c2765f1700612441a9",
    "susfs": "937215cb3a1b1f333d764c366c7a49972fa8e7a0",
}
for key, sha in expected_sources.items():
    if sources.get(key, {}).get("sha") != sha:
        raise SystemExit(f"unexpected {key} pin in experimental COS17 state")

tree = ET.parse(manifest_path)
projects = {p.attrib.get("name"): p.attrib for p in tree.getroot().findall("project")}
if projects.get("android_kernel_common_oneplus_sm8750", {}).get("revision") != expected_sources["kernel_common"]:
    raise SystemExit("fallback manifest common-kernel SHA mismatch")
if projects.get("android_kernel_modules_and_devicetree_oneplus_sm8750", {}).get("revision") != expected_sources["kernel_modules"]:
    raise SystemExit("fallback manifest modules SHA mismatch")

required_workflow_text = [
    "Experimental OP13 Global ColorOS 17 source-fallback",
    "op13-experimental-coloros17-source-fallback.json",
    "OP13-GLOBAL-EXPERIMENTAL-6.6.118.json",
    "oneplus_13_global_cos17_source_fallback_6.6.118.xml",
    "EXPERIMENTAL-COS17-CPH2653-SOURCE-FALLBACK",
    "upload_final_zip: false",
]
for value in required_workflow_text:
    if value not in workflow:
        raise SystemExit(f"experimental COS17 workflow missing contract text: {value}")

# GitHub Actions must publish the inner, directly flashable AK3 ZIP. Its
# default artifact-archive wrapper is not understood by KernelSU Kernel Flash.
required_direct_zip_contract = [
    'unzip -tq "$staged_zip"',
    'META-INF/com/google/android/update-binary',
    'META-INF/com/google/android/updater-script',
    'tools/ak3-core.sh',
    'entries_file="$RUNNER_TEMP/cos17-ak3-zip-entries.txt"',
    'KernelSU/uapi/supercall.h',
    'KERNEL_SU_UAPI_VERSION',
    'kernel_driver_uapi_version',
    'path: ${{ github.workspace }}/${{ steps.stage.outputs.staged_name }}',
    'path: ${{ steps.stage.outputs.notice }}',
]
for value in required_direct_zip_contract:
    if value not in workflow:
        raise SystemExit(f"experimental COS17 direct AK3 contract missing {value}")
if workflow.count("archive: false") < 2:
    raise SystemExit("experimental AK3 ZIP and notice must be uploaded separately without outer ZIP wrappers")
if 'path: |\n            ${{ github.workspace }}/${{ steps.stage.outputs.staged_name }}' in workflow:
    raise SystemExit("flashable ZIP must never share a zipped artifact bundle with the notice")

print("PASS: experimental OP13 ColorOS 17 source-fallback contract")
PY
