# Neural Substrate OS

**An experimental AI-native operating system.**

The long-term goal is an OS whose *control plane is an AI*: processes, files, devices, and user intent are mediated by an agent rather than a pile of static daemons and click-menus.

The short-term lab is a **rooted Android emulator** (Linux kernel + Android userspace). We do **not** pretend we can delete Linux tomorrow. We treat the emulator as a disposable machine where we:

1. Get root.
2. Inspect the real Linux/Android stack.
3. Replace *userspace pieces* one by one with AI-driven services.
4. Grow a new OS personality on top of a still-living kernel.

> Honest constraint: replacing the Linux *kernel* is a multi-year research program (drivers, memory, scheduling, hardware). This repo starts where a small team can actually ship: **AI userspace + policy + intent layer**, with a path toward a custom kernel later.

Repo: https://github.com/christhepimp/neural-substrate-os

---

## What “the OS is an AI” means here

| Conventional OS | Neural Substrate OS |
|---|---|
| Syscalls + daemons you configure | An agent that *understands goals* and issues syscalls |
| Files you name and organize | A memory store the agent indexes, summarizes, and retrieves |
| Apps you launch | Skills / tools the agent composes |
| Notifications you dismiss | A planner that decides what deserves attention |
| Root shell for power users | A constrained privileged agent with an audit log |

The kernel still schedules threads and talks to hardware. The *personality* of the machine is the model + tool loop.

---

## Lab: rooted Android emulator (2026)

Recommended starting points, ranked for *kernel/userspace access*, not gaming FPS.

### 1. Android Studio AVD + rootAVD / Magisk (best for kernel work)

- Official QEMU-based emulator, latest API images.
- Root with [rootAVD](https://gitlab.com/newbit/rootAVD) or Magisk patches; or [AERoot](https://github.com/quarkslab/AERoot) for on-the-fly root on Google Play AVDs.
- Launch with writable system when needed:

```bash
emulator -avd YourAvd -writable-system -selinux disabled
adb root && adb remount
```

AOSP / Google APIs images are easier to root than Play Store images.

### 2. BlueStacks 5 — built-in Root Mode

Settings → Advanced → enable **Root access**. Fast to get `su`, weaker for deep kernel experiments.

### 3. Genymotion Desktop

Some images support dynamic root. Good for QA; VirtualBox-based.

### 4. Waydroid (Linux host)

Android 13 (LineageOS) in an LXC container **sharing the host Linux kernel**. Best if your daily machine is Linux and you want near-native performance. Root depends on the image / container privileges — not a full separate kernel to rewrite, but excellent for userspace replacement experiments.

### 5. Cloud / pre-rooted

Redfinger and similar cloud emulators advertise pre-rooted images. Useful as a sandbox, not as a kernel lab.

**Practical pick for this project:** Android Studio AVD (x86_64 or arm64) + Magisk/rootAVD + `adb shell su`. That is the path documented under `docs/emulator-lab.md`.

---

## Architecture (v0)

```
+----------------------------------------------------------+
|  Intent / conversation UI  (voice, text, screen)         |
+---------------------------+------------------------------+
|  Agent runtime            |  Tool bus                    |
|  planner, memory, policy  |  files, apps, net, sensors   |
+---------------------------+------------------------------+
|  Substrate services (our userspace)                      |
|  init-lite, capability broker, audit log                 |
+----------------------------------------------------------+
|  Linux kernel (Android emulator or host)                 |
+----------------------------------------------------------+
|  Hardware / hypervisor (QEMU, KVM, VirtualBox, LXC)      |
+----------------------------------------------------------+
```

See `docs/architecture.md` and `docs/roadmap.md`.

---

## Repo layout

```
docs/                 vision, lab setup, architecture, roadmap
substrate/            future: capability broker, audit, init-lite
agent/                future: planner loop, tools, memory
lab/                  scripts for emulator, adb, root checks
LICENSE
```

---

## Status

Scaffold + research notes. No custom kernel. No claim that Linux has been replaced.

Next concrete steps:

1. Stand up a rooted AVD and capture `uname -a`, `/proc/version`, mount table.
2. Run `lab/probe-host.sh` against `adb shell`.
3. Define the first tool the agent is allowed to call: `list_processes`, `read_logcat`, `notify`.

---

## License

MIT. See `LICENSE`.
