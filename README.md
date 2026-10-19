# AVA-V0

AVA-V0 is the smallest AVA variant: an OpenCode agent using
VirtuosoBridgeLite directly. It intentionally excludes every AVA-V1 auxiliary
system, including document retrieval, memory, Wiki, OCR, spreadsheet tooling,
custom TypeScript Bridge tools, and the AVA Python runtime.

## Included

- Full reviewed VirtuosoBridgeLite 0.8.0 source tree
- Upstream `virtuoso`, `spectre`, `netlist`, and `optimizer` skills
- Minimal OpenCode agent and permission configuration
- Minimal Python 3.11 dependency project
- Bridge configuration template plus isolated `work/` and `artifacts/` areas
- Transparent `scripts/bridge.sh` launcher for the S environment

## Layout

```text
AVA-V0/
├── AGENTS.md
├── README.md
├── opencode.json
├── pyproject.toml
├── uv.lock
├── .opencode/
│   ├── agents/ava-v0.md
│   └── skills/{virtuoso,spectre,netlist,optimizer}/
├── config/bridge.env.template
├── scripts/bridge.sh
├── vendor/
│   ├── bridge-provenance.json
│   └── virtuoso-bridge-lite/
├── work/
└── artifacts/
```

## S quick start

If S already has a compatible `virtuoso-bridge` executable, clone this repo and
run it directly through the transparent launcher:

```bash
./scripts/bridge.sh --help
./scripts/bridge.sh status
```

The launcher prefers `.venv/bin/virtuoso-bridge`, then
`AVA_V0_BRIDGE`, then an existing `virtuoso-bridge` on `PATH`. It can also use
Python 3.11 plus the vendored source through `AVA_V0_PYTHON`.

If S does not already have the required Python packages, create the project
environment from the lock:

```bash
uv sync --frozen
./scripts/bridge.sh init user@host
./scripts/bridge.sh start
./scripts/bridge.sh status
```

For a jump host, initialize with
`./scripts/bridge.sh init user@host -J user@jump`.
The generated configuration is local and ignored by Git. Do not copy the
template unchanged: `init` fills the port placeholders and writes the supported
user-level configuration.

Open this directory as the OpenCode project. The default `ava-v0` agent can
load the four project skills and request native approval before commands that
start, stop, or operate the Bridge.

The intended topology is S OpenCode/AVA → BridgeLite → R relay → C
Virtuoso/RAMIC. Treat SSH, file transfer, X11, and standalone Spectre as
available only after their respective side channels pass a live check.

## Provenance and current validation

The Bridge source was copied from AVA-V1's reviewed vendor at source revision
`97e2e55bea905b909475175870064390eb3b5a94`. Upstream identity and the canonical
vendor tree hash remain recorded in `vendor/bridge-provenance.json`.

Local source/hash/import/CLI tests do not prove access to a real Cadence
installation. Live Virtuoso and Spectre validation remains pending until this
project is configured against the intended machine.
