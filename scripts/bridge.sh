#!/usr/bin/env sh
# Direct VirtuosoBridgeLite launcher for the S OpenCode/AVA host.
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

if [ -x "$repo_dir/.venv/bin/virtuoso-bridge" ]; then
    exec "$repo_dir/.venv/bin/virtuoso-bridge" "$@"
fi

if [ -n "${AVA_V0_BRIDGE:-}" ]; then
    [ -x "$AVA_V0_BRIDGE" ] || {
        echo "ERROR: AVA_V0_BRIDGE is not executable: $AVA_V0_BRIDGE" >&2
        exit 2
    }
    exec "$AVA_V0_BRIDGE" "$@"
fi

if command -v virtuoso-bridge >/dev/null 2>&1; then
    exec "$(command -v virtuoso-bridge)" "$@"
fi

if [ -n "${AVA_V0_PYTHON:-}" ]; then
    python=$AVA_V0_PYTHON
elif command -v python3.11 >/dev/null 2>&1; then
    python=$(command -v python3.11)
else
    echo "ERROR: no AVA-V0 venv, virtuoso-bridge executable, or Python 3.11 was found." >&2
    echo "Run 'uv sync --frozen' or set AVA_V0_BRIDGE/AVA_V0_PYTHON." >&2
    exit 2
fi

version=$($python -c 'import sys; print("%d.%d" % sys.version_info[:2])')
[ "$version" = 3.11 ] || {
    echo "ERROR: AVA-V0 requires Python 3.11; selected interpreter reports $version." >&2
    exit 2
}

bridge_src="$repo_dir/vendor/virtuoso-bridge-lite/src"
if [ -n "${PYTHONPATH:-}" ]; then
    export PYTHONPATH="$bridge_src:$PYTHONPATH"
else
    export PYTHONPATH="$bridge_src"
fi

exec "$python" -m virtuoso_bridge.cli "$@"
