"""Offline installation smoke test; no live Virtuoso connection is required."""

from __future__ import annotations

import importlib.metadata
from pathlib import Path
import subprocess
import sys

import virtuoso_bridge
from virtuoso_bridge import VirtuosoClient


def main() -> None:
    version = importlib.metadata.version("virtuoso-bridge")
    assert version == "0.8.0", f"unexpected version: {version}"
    assert VirtuosoClient is not None

    package_root = Path(virtuoso_bridge.__file__).resolve().parent
    required_resources = (
        package_root / "resources/.env_template",
        package_root / "virtuoso/basic/resources/ramic_bridge.il",
        package_root / "virtuoso/schematic/cdf_param_filters.yaml",
    )
    for resource in required_resources:
        assert resource.is_file(), f"missing package resource: {resource}"

    cli = Path(sys.executable).with_name("virtuoso-bridge")
    assert cli.is_file(), f"missing console command: {cli}"
    result = subprocess.run(
        [str(cli), "--help"],
        check=False,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr
    output = result.stdout + result.stderr
    for command in ("status", "eval", "load"):
        assert command in output, f"CLI help does not contain {command!r}"
    print(f"PASS: virtuoso-bridge {version} imports and direct CLI starts")


if __name__ == "__main__":
    main()
