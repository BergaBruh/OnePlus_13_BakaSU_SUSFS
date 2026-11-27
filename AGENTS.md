# Repository guidance

- PR CI runs the shell contract tests on Ubuntu with `jq` and Python 3 with PyYAML installed: `for test in tests/*-test.sh; do bash "$test" || exit; done`. It also syntax-checks test scripts with `bash -n` and parses `.github` YAML with PyYAML; see `.github/workflows/pr-ci.yml`.
- This repository orchestrates kernel builds; source trees and toolchains are fetched separately. For the local baseline build sequence and prerequisites, see `docs/op13-6.6.118-baseline-build.md`. Its output is a historical custom-ROM `Image`, not a stock-compatible flashable package; do not flash it.
- ColorOS 17 release builds require matching official source SHAs; do not publish a release ZIP from an OxygenOS source fallback. Select SUSFS branches by kernel KMI generation and Linux major/minor, not userspace Android version.
