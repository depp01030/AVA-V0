# AVA-V0

AVA-V0 is the smallest AVA variant: an OpenCode agent using
VirtuosoBridgeLite directly. It intentionally excludes every AVA-V1 auxiliary
system, including document retrieval, memory, Wiki, OCR, spreadsheet tooling,
custom TypeScript Bridge tools, and the AVA Python runtime.

## Included

- Full reviewed VirtuosoBridgeLite 0.8.0 source tree
- Upstream `virtuoso`, `spectre`, `netlist`, and `optimizer` skills
- Minimal OpenCode agent and permission configuration
- Ubuntu 24.04 x86_64 / CPython 3.11 offline dependency wheelhouse
- Bridge configuration template plus isolated `work/` and `artifacts/` areas

## Layout

```text
AVA-V0/
├── AGENTS.md
├── README.md
├── opencode.json
├── .opencode/
│   ├── agents/ava-v0.md
│   └── skills/{virtuoso,spectre,netlist,optimizer}/
├── config/bridge.env.template
├── offline/
│   ├── install.sh
│   ├── requirements.txt
│   ├── wheelhouse/
│   ├── bundle-manifest.json
│   └── SHA256SUMS
├── vendor/
│   ├── bridge-provenance.json
│   └── virtuoso-bridge-lite/
├── work/
└── artifacts/
```

## S quick start

S is the former B/Gemma host: Ubuntu 24.04 x86_64, glibc 2.39, with
`python3.11` and `uv` already present. Clone or extract the repository on S,
then perform the one-time installation without network access:

```bash
bash ./offline/install.sh
source .venv/bin/activate
```

Calling the installer through `bash` also works when an archive or transfer
tool did not preserve its executable bit.

If `/usr/bin/env: 'bash\r': No such file or directory` appears, a Windows or
FTP transfer converted LF files to CRLF. Restore the immutable installation
payload from Git, then run it through Bash:

```bash
git config core.autocrlf false
git restore --source=HEAD --worktree -- offline vendor
bash ./offline/install.sh
```

Transfer release archives and wheels in binary mode. Do not use FTP ASCII mode.

Start OpenCode from that activated shell. The agent then uses the installed
VirtuosoBridgeLite command directly; AVA-V0 adds no runtime launcher or wrapper:

```bash
virtuoso-bridge --help
virtuoso-bridge init user@host
virtuoso-bridge start
virtuoso-bridge status
virtuoso-bridge eval 'getCurrentTime()'
```

For a jump host, initialize with
`virtuoso-bridge init user@host -J user@jump`.
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

The offline wheels were reduced from the reviewed V1 CPython 3.11 manylinux
bundle to BridgeLite's required dependency closure. `offline/install.sh`
verifies every payload hash, disables indexes and network resolution, installs
the vendored source in editable mode exactly as the upstream setup does, and
checks that `.venv/bin/virtuoso-bridge` starts.

Local source/hash/import/CLI tests do not prove access to a real Cadence
installation. Live Virtuoso and Spectre validation remains pending until this
project is configured against the intended machine.
