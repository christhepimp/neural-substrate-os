# Roadmap

## Phase 0 — Lab (now)

- [x] Public repo + vision docs
- [ ] Rooted AVD running
- [ ] `lab/probe-host.sh` produces a capture on a real emulator
- [ ] Decision: AVD vs Waydroid as daily lab

## Phase 1 — Observe

- Agent can list processes, read logcat, summarize battery/network.
- All actions go through a fake broker (allow-list in a JSON file).

## Phase 2 — Act (narrow)

- Tools: notify, open URL, write a file under `/sdcard/substrate/`.
- Audit log on disk.
- One policy: never grant `su` to third-party APKs.

## Phase 3 — Remember

- Local embedding store for notes, screenshots text, command history.
- Session summaries survive emulator snapshots.

## Phase 4 — Personality

- Boot message is the agent, not a launcher grid.
- Android launcher becomes optional.

## Phase 5 — Kernel research (not scheduled)

Only after L2/L3 are real:

- Custom init + fewer Android services
- Evaluate seL4 / Redox / a Linux-compat unikernel as L1
- Driver story (virtio first — emulator hardware is the only target that makes sense)

## Non-goals for this year

- Shipping a phone ROM
- Replacing the Linux syscall ABI
- Training a foundation model from scratch inside the emulator
