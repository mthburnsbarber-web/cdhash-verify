# macOS Stale-Binary Release Checklist

Use this when a fix appears to build correctly but the installed app still
behaves like the old version.

## Prove identity

- Build the candidate bundle.
- Launch the app through the same path a customer or tester uses.
- Run `cdhash-verify` against the live bundle id or process id.
- Treat a matching version number as metadata only. The CDHash is the identity.

```bash
./cdhash-verify com.example.MyApp ./build/Release/MyApp.app
```

## If it is stale

- Quit every running copy of the app.
- Remove old copies from `/Applications`, `~/Applications`, build output
  folders, and downloaded DMGs.
- Reinstall from the exact candidate artifact.
- Relaunch from the intended installed path.
- Run `cdhash-verify` again.

## Release receipt

Record:

- candidate path;
- bundle id;
- version and build number;
- candidate CDHash;
- running CDHash;
- install path;
- verification time;
- command output.

Do not call a package verified until the running process matches the candidate
artifact and the original bug has been replayed in that running app.
