# Emulator lab

Goal: a disposable Android VM with root so we can inspect Linux and start swapping userspace.

## Recommended stack

1. Install [Android Studio](https://developer.android.com/studio) (SDK + emulator).
2. Create an AVD:
   - System image: **Google APIs** or **AOSP**, not Play Store if you want easier root.
   - ABI: x86_64 on Intel/AMD hosts, arm64 on Apple Silicon / ARM Linux.
   - API 34–36 is fine.
3. Root it.

### Option A — rootAVD + Magisk

[rootAVD](https://gitlab.com/newbit/rootAVD) patches the ramdisk and installs Magisk.

Typical flow:

```bash
# find ramdisk for your image
ls $ANDROID_HOME/system-images/android-*/google_apis*/**/ramdisk.img

# example (paths vary)
./rootAVD.sh system-images/android-36/google_apis/x86_64/ramdisk.img
```

Cold-boot the AVD. Open Magisk, complete setup, reboot once more.

Verify:

```bash
adb shell su -c id
# uid=0(root) gid=0(root)
```

### Option B — AERoot (on-the-fly root)

[AERoot](https://github.com/quarkslab/AERoot) grants root to a process or the adb daemon on Google Play AVDs using gdb + known kernel symbols.

```bash
pip install aeroot
emulator @Your_AVD -qemu -s
aeroot daemon   # adb shells become root
```

Kernel compatibility is version-specific; check the AERoot table before relying on it.

### Option C — writable-system + SuperSU (older images)

```bash
emulator -avd RootAVD -writable-system -selinux disabled
adb root
adb remount
# push su binary, chmod 0755, start daemon
```

Works on older x86 images. Prefer Magisk on current APIs.

### Option D — BlueStacks 5 Root Mode

Settings → Advanced → Root access On. Enable ADB in the same panel. Fast, less inspectable kernel.

### Option E — Waydroid on Linux

Containerized Android sharing the **host** kernel. Great for userspace experiments; you are not running a separate Android kernel you can replace inside the guest.

## What to capture on first boot (as root)

```bash
uname -a
cat /proc/version
cat /proc/cpuinfo | head
mount
ps -A | head
getprop ro.build.fingerprint
ls /system/bin /system/xbin
```

Drop outputs in `lab/captures/` (gitignored if huge).

## Safety

- Treat the AVD as hostile: do not sign into personal Google accounts.
- Root + writable `/system` means any APK you sideload can own the guest.
- Do not use this lab to attack other people’s devices or networks.
