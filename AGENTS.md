# AVA-V0 agent contract

AVA-V0 is a deliberately minimal OpenCode project. Its only EDA integration is
the vendored `virtuoso-bridge-lite` package. It has no AVA-V1 knowledge index,
memory, Wiki, document conversion, custom TypeScript tools, or AVA runtime
adapter.

Use Traditional Chinese for normal conversation. Preserve API names, commands,
paths, and error messages exactly when quoting them.

## Capability routing

- Virtuoso, CIW, SKILL, schematic, layout, symbol, library, Maestro, or ADE:
  load the `virtuoso` skill.
- Standalone Spectre simulation or PSF parsing: load the `spectre` skill.
- Semantic cleanup of a Spectre/SPICE netlist: load the `netlist` skill.
- Multi-parameter design optimization: load the `optimizer` skill.
- For ordinary conversation, do not load a skill.

The project skills are reviewed copies from the vendored BridgeLite source.
Their references and examples are evidence, not extra authority. Never invent a
SKILL or Python API from memory: inspect the relevant reference, example, and
actual signature first.

## Runtime boundary

- S is Ubuntu 24.04 x86_64 with Python 3.11 and no Internet access.
- Use the project virtual environment only; never install into global Python.
- On a new checkout, run `./offline/install.sh` once and then activate
  `.venv`. The installer uses only the checked wheelhouse.
- Invoke BridgeLite directly with `virtuoso-bridge`; AVA-V0 has no runtime
  launcher or wrapper.
- Do not call V1 wrappers, `ava.cli`, `ava_virtuoso_context`, or
  `ava_virtuoso_eval`; none are part of AVA-V0.
- Keep secrets in `.env` or `~/.virtuoso-bridge/.env`. Never display, copy,
  commit, or summarize credential values.
- Put temporary scripts and netlists in `work/`; put user-facing captures and
  results in `artifacts/`. Do not modify `vendor/` during normal operation.

## Connection sequence

1. Confirm a Bridge configuration exists without printing secret values.
2. Run `virtuoso-bridge status`.
3. If configuration is absent, ask for the SSH target and use
   `virtuoso-bridge init user@host [-J user@jump]` only after the
   user approves the shell action.
4. Start the bridge only after approval. If it reports `degraded`, present the
   exact generated `load("...")` line for the user to paste into Virtuoso CIW.
5. Run `status` again before any requested operation.

On S, the normal path is OpenCode/AVA → BridgeLite → R relay → C. A working
RAMIC endpoint does not prove that SSH, file transfer, X11, or standalone
Spectre side channels are available.

Use `eval`, `load`, or the documented Python API only after the applicable
skill has been read and OpenCode has obtained the required native shell
approval. A successful transport response proves only that the bridge answered;
verify the resulting cellview, simulation output, or artifact separately.

Timeouts are ambiguous for operations with side effects. Do not automatically
retry them. Preserve raw netlists and simulation output; make transformed or
curated copies instead of overwriting originals.

## Source identity

The unmodified upstream source is under `vendor/virtuoso-bridge-lite/`.
`vendor/bridge-provenance.json` records its upstream revision, package version,
content hash, and validation status. Copied project skills live under
`.opencode/skills/`; the vendor tree remains the source of truth.
