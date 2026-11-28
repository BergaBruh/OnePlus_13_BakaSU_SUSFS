from pathlib import Path
import os
import subprocess
import tempfile
import textwrap

text = Path(".github/actions/build-kernel/action.yml").read_text(encoding="utf-8")
step = text.split("    - name: Add BBG\n", 1)[1].split("    - name:", 1)[0]
script = textwrap.dedent(step.split("        setup_script=", 1)[1].split("        echo \"CONFIG_BBG=y\"", 1)[0])
script = "setup_script=" + script
with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    curl = root / "curl"
    curl.write_text("#!/bin/sh\nwhile [ \"$1\" != --output ]; do shift; done\nout=$2; url=$3\ncase \"$url\" in *raw.githubusercontent.com*) echo 504 >&2; exit 22;; esac\n[ \"${FAIL_ALL:-0}\" = 0 ] || exit 22\nprintf \"#!/bin/sh\\ntouch %s/ran\\n\" \"$TEST_DIR\" > \"$out\"\n")
    curl.chmod(0o755)
    env = dict(os.environ, PATH=directory + os.pathsep + os.environ["PATH"], TEST_DIR=directory)
    subprocess.run(["bash", "-eu", "-c", script], env=env, check=True)
    assert (root / "ran").exists(), "fallback must execute the downloaded installer"
    (root / "ran").unlink()
    env["FAIL_ALL"] = "1"
    result = subprocess.run(["bash", "-eu", "-c", script], env=env)
    assert result.returncode != 0 and not (root / "ran").exists(), "failed downloads must not run a partial script"
print("PASS: BBG download fallback and fail-closed handling")
