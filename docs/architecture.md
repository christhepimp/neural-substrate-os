# Architecture

Neural Substrate OS is layered. Linux stays at the bottom until there is a real reason and a real team to write a kernel.

## Layers

### L0 — Hardware / hypervisor

QEMU (Android emulator), KVM, VirtualBox, or LXC (Waydroid). Not our problem yet.

### L1 — Kernel

Linux. Scheduling, MMU, drivers, binder (on Android). We observe it; we do not fork it in v0.

### L2 — Substrate services

Small privileged programs we *do* own:

- **capability broker** — the agent never gets raw `su` for everything. It asks for named capabilities (`net.listen`, `fs.read.home`, `proc.signal`).
- **audit log** — every privileged action is appended, hash-chained.
- **init-lite** — start/stop our services without fighting Android `init` more than we must.

### L3 — Agent runtime

Loop:

1. Observe (logs, sensors, user text, screen text).
2. Plan (goal + constraints + tools).
3. Act (tool calls through the broker).
4. Remember (summaries into a local store).

Policy sits here: what the model is *allowed* to want.

### L4 — Interface

Chat, voice, and eventually a spatial UI. The UI is not the OS; it is a client of the agent.

## Why not “replace Linux” first?

A kernel needs drivers, filesystems, interrupt handling, and years of hardening. An AI OS that cannot boot a display or talk to a NIC is a paperweight.

Userspace replacement is the wedge:

- replace Settings with a conversation
- replace file managers with memory + retrieval
- replace cron with a planner
- replace notification shade with attention policy

If that layer works, a custom kernel becomes a later optimization (unikernel, seL4 + Linux personality, etc.), not the first commit.

## Trust model

The model is untrusted. The broker is trusted. The kernel is trusted-for-now.

No tool that can wipe userdata or open a raw socket ships without an explicit capability grant recorded in the audit log.
