# cdhash-verify

Prove the app you're **running** is the artifact you **built** — in one command.

```
$ cdhash-verify com.example.myapp ./build/Release/MyApp.app
running    a3f81c…  pid=48221  version=1.5 (6)
           source: memory (launchctl procinfo)
candidate  a3f81c…  ./build/Release/MyApp.app  version=1.5 (6)
verdict    MATCH — the running code IS this artifact
```

## Why

Every Mac developer eventually loses an afternoon to a stale binary: you ship a
fix, relaunch, and the bug is still there — because the thing you launched
wasn't the thing you built. Spotlight launched an old replica with the same
bundle id. A copy step silently failed. Two builds carry the same build number.

The traps that make this hard to catch:

- **Version strings are not identity.** Two different binaries can report the
  same `CFBundleVersion`.
- **mtimes are not identity.** Copying a bundle refreshes timestamps.
- **The disk is not the process.** The on-disk bundle can be replaced after
  launch; the old code keeps running.

The only identity a signed macOS binary has is its **code-directory hash
(CDHash)**. This script reads the CDHash of the *live process* (via
`launchctl procinfo`, falling back to `codesign` on the launch path with a
clear warning) and compares it to the CDHash of a candidate `.app`.

## Usage

```
cdhash-verify <pid | bundle-id> <path/to/Candidate.app>
```

Exit codes: `0` match, `1` stale, `2` usage/lookup error — so it drops straight
into CI or a deploy script:

```bash
./deploy.sh && cdhash-verify com.example.myapp ./dist/MyApp.app
```

## Requirements

macOS. Uses only system tools: `codesign`, `launchctl`, `PlistBuddy`,
`osascript`. No dependencies.

## Free templates

- [Stale-binary release checklist](docs/mac-release-stale-binary-checklist.md)
  — identity proof steps before calling a macOS fix installed.
- [Release gate script](examples/release-gate.sh) — copy into a local release
  lane.
- [GitHub Action template](examples/github-action.yml) — candidate-signature
  CI starter.

## License

MIT
