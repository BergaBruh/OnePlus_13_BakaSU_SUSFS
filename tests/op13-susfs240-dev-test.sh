#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
from pathlib import Path
import re
import subprocess
import textwrap

workflow = Path('.github/workflows/build-op13-experimental-susfs240-dev.yml').read_text()
for required in (
    'workflow_dispatch:', 'refs/heads/dev', 'ksu_branch_or_hash: ${{ steps.pins.outputs.dev_sha }}',
    'susfs_commit_hash_or_branch: f98f08223bbf469cc0a1542166383d253557fc32',
    "experimental_susfs_240: 'true'", 'upload_final_zip: false',
    'ACTUAL_DEV', 'ACTUAL_SUSFS', 'ACTUAL_VERSION', 'KERNEL_SU_UAPI_VERSION',
    'ColorOS 17 uses OxygenOS source fallback; do not flash or publish',
):
    assert required in workflow, required
assert 'gh release' not in workflow
assert '\n  push:' not in workflow
for script in re.findall(r'(?ms)^        run: \|\n(.*?)(?=^      - name:|\Z)', workflow):
    subprocess.run(['bash', '-n'], input=textwrap.dedent(script), text=True, check=True)
print('PASS: SUSFS 2.4 / BakaSU dev diagnostic contract')
PY
