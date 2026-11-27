#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
from pathlib import Path
import json
import re
import subprocess
import textwrap

for path in Path('.github/workflows').glob('*.yml'):
    text = path.read_text()
    assert 'liblz4-tool' not in text, f'{path}: use the lz4 package'
    for line in text.splitlines():
        if 'apt-get' in line and 'update -qq' in line:
            assert 'Dir::Etc::sourcelist=/etc/apt/sources.list.d/ubuntu.sources' in line
            assert 'Dir::Etc::sourceparts=-' in line

for path in Path('configs').rglob('*.json'):
    config = json.loads(path.read_text())
    for feature in ('hmbird', 'bbg', 'bbr', 'bbr3', 'ttl', 'ip_set', 'unicode', 'ntsync'):
        assert config.get(feature) is True, f'{path}: {feature} must be enabled'

for state_path in ('.github/update-state/op13-upstreams.json', '.github/update-state/op13-experimental-resukisu-susfs.json', '.github/update-state/op13-experimental-coloros17-source-fallback.json'):
    sources = json.loads(Path(state_path).read_text())['sources']
    assert sources['resukisu']['ref'] == 'dev'
    assert sources['resukisu']['sha'] == 'd8d96fca0586e852d7f14a1a8b808d03201b136c'
    assert sources['susfs']['sha'] == 'f98f08223bbf469cc0a1542166383d253557fc32'
    assert sources['susfs']['version'] == 'v2.4.0'

for path in ('.github/workflows/build-op13-all.yml', '.github/workflows/build-op13-experimental-resukisu-susfs.yml', '.github/workflows/build-op13-experimental-coloros17.yml'):
    text = Path(path).read_text()
    assert "experimental_susfs_240: 'true'" in text
    assert text.index('Verify SUSFS 2.4 and BakaSU driver UAPI') < text.index('uses: actions/upload-artifact@v7')
    assert 'KERNEL_SU_UAPI_VERSION' in text
aggregate = Path('.github/workflows/build-op13-all.yml').read_text()
assert "if: ${{ github.event_name == 'workflow_dispatch' && inputs.publish_release }}" in aggregate

workflow = Path('.github/workflows/build-op13-experimental-susfs240-dev.yml').read_text()
for required in (
    'workflow_dispatch:', 'refs/heads/dev', 'ksu_branch_or_hash: ${{ steps.pins.outputs.dev_sha }}',
    'susfs_commit_hash_or_branch: f98f08223bbf469cc0a1542166383d253557fc32',
    "experimental_susfs_240: 'true'", 'upload_final_zip: false',
    'ACTUAL_DEV', 'ACTUAL_SUSFS', 'ACTUAL_VERSION', 'KERNEL_SU_UAPI_VERSION',
    'ColorOS 17 uses OxygenOS source fallback; do not flash or publish',
):
    assert required in workflow, required
action = Path('.github/actions/build-kernel/action.yml').read_text()
assert '[ "$OP_OS_VERSION" = COS17 ] && [ "$OP_MANIFEST" = oneplus_13_global_cos17_source_fallback_6.6.118.xml ]' in action
assert 'HMBIRD_OS=A16' in action
assert 'gh release' not in workflow
assert '\n  push:' not in workflow
for script in re.findall(r'(?ms)^        run: \|\n(.*?)(?=^      - name:|\Z)', workflow):
    subprocess.run(['bash', '-n'], input=textwrap.dedent(script), text=True, check=True)
print('PASS: SUSFS 2.4 / BakaSU dev diagnostic contract')
PY
