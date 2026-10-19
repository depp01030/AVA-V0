#!/usr/bin/env bash
# One-time, network-free installation for the S host.
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
venv_dir=${AVA_V0_VENV:-$repo_dir/.venv}
python_command=${PYTHON_COMMAND:-python3.11}

if [ "$(uname -s)" != "Linux" ] || [ "$(uname -m)" != "x86_64" ]; then
    echo "ERROR: this bundle targets Linux x86_64." >&2
    exit 2
fi

if [ ! -r /etc/os-release ]; then
    echo "ERROR: /etc/os-release is unavailable." >&2
    exit 2
fi

# shellcheck disable=SC1091
. /etc/os-release
if [ "${ID:-}" != "ubuntu" ] || [ "${VERSION_ID:-}" != "24.04" ]; then
    echo "ERROR: this bundle targets Ubuntu 24.04; found ${ID:-unknown} ${VERSION_ID:-unknown}." >&2
    exit 2
fi

command -v uv >/dev/null 2>&1 || {
    echo "ERROR: uv is required and was not found on PATH." >&2
    exit 2
}
command -v "$python_command" >/dev/null 2>&1 || {
    echo "ERROR: $python_command was not found on PATH." >&2
    exit 2
}
"$python_command" -c 'import sys; assert sys.version_info[:2] == (3, 11), sys.version'

if [ -e "$venv_dir" ]; then
    echo "ERROR: refusing to overwrite existing environment: $venv_dir" >&2
    exit 2
fi

(cd "$script_dir" && sha256sum -c SHA256SUMS)

uv venv --python "$python_command" "$venv_dir"
venv_python="$venv_dir/bin/python"

uv pip install \
    --python "$venv_python" \
    --offline \
    --no-index \
    --find-links "$script_dir/wheelhouse" \
    --require-hashes \
    --requirement "$script_dir/requirements.txt"

# Match the official editable install. This creates .venv/bin/virtuoso-bridge;
# it is an installation step, not a runtime wrapper.
uv pip install \
    --python "$venv_python" \
    --offline \
    --no-index \
    --no-build-isolation \
    --no-deps \
    --editable "$repo_dir/vendor/virtuoso-bridge-lite"

"$venv_python" "$script_dir/smoke_test.py"

printf '\nAVA-V0 offline installation passed.\n'
printf 'Run: source %s/bin/activate\n' "$venv_dir"
printf 'Then start OpenCode from this shell; the agent can call virtuoso-bridge directly.\n'
