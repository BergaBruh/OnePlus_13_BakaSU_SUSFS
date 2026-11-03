#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

python3 - "$repo_root" <<'PY'
import json
from pathlib import Path
import sys

root = Path(sys.argv[1])
state = json.loads((root / ".github/update-state/op13-upstreams.json").read_text())
workflow = (root / ".github/workflows/build-op13-all.yml").read_text()
action = (root / ".github/actions/build-kernel/action.yml").read_text()

target = state["target"]
requested = target.get("requested_target", {})

if target.get("firmware_family") != "OxygenOS":
    raise SystemExit("active target must remain the last known-good OxygenOS baseline until ColorOS sources are published")
if requested.get("firmware_family") != "ColorOS":
    raise SystemExit("requested target must identify ColorOS")
if requested.get("model") != "CPH2653":
    raise SystemExit("requested ColorOS target must be CPH2653")
if requested.get("userspace_android_version") != "android17":
    raise SystemExit("requested ColorOS target must record Android 17 userspace")
if requested.get("source_status") != "awaiting_official_oneplusoss_pair":
    raise SystemExit("ColorOS target must remain source-gated before activation")

if "^(OOS|COS)[0-9]+$" not in action:
    raise SystemExit("build action must accept versioned COS targets")
for allowed in ("configs/(oos15|oos16|coloros17)", "manifests/(oos15|oos16|coloros17)"):
    if allowed not in workflow:
        raise SystemExit(f"workflow must allow future {allowed} paths")
if 'expected_susfs_ref="gki-$kmi_android-$linux_kernel_mm"' not in workflow:
    raise SystemExit("SUSFS branch must be derived from actual KMI/kernel state")

# Until matching official CPH2653 ColorOS 17 source SHAs are published,
# permit only the explicitly experimental source-fallback target.
allowed_configs = {"OP13-GLOBAL-EXPERIMENTAL-6.6.118.json"}
allowed_manifests = {"oneplus_13_global_cos17_source_fallback_6.6.118.xml"}
actual_configs = {p.name for p in (root / "configs/coloros17").glob("*.json")} if (root / "configs/coloros17").exists() else set()
actual_manifests = {p.name for p in (root / "manifests/coloros17").glob("*.xml")} if (root / "manifests/coloros17").exists() else set()

if actual_configs != allowed_configs:
    raise SystemExit(f"only the approved experimental ColorOS 17 config is allowed before official sources exist: {actual_configs}")
if actual_manifests != allowed_manifests:
    raise SystemExit(f"only the approved experimental ColorOS 17 manifest is allowed before official sources exist: {actual_manifests}")
if "slug: coloros17-" in workflow or "slug: cos17-" in workflow:
    raise SystemExit("do not publish a ColorOS 17 row in the normal release matrix before official matching sources exist")

experimental_state = root / ".github/update-state/op13-experimental-coloros17-source-fallback.json"
if not experimental_state.is_file():
    raise SystemExit("experimental ColorOS 17 source-fallback state file is required")
experimental = json.loads(experimental_state.read_text())
if experimental.get("validation", {}).get("experimental") is not True:
    raise SystemExit("ColorOS 17 fallback must remain explicitly experimental")
if experimental.get("validation", {}).get("publish_release") is not False:
    raise SystemExit("ColorOS 17 fallback must not publish a normal release")
if experimental.get("target", {}).get("source_fallback") is not True:
    raise SystemExit("ColorOS 17 fallback must identify the OxygenOS source fallback")

print("PASS: OP13 ColorOS 17 preparation remains source-gated with explicit experimental fallback")
PY
