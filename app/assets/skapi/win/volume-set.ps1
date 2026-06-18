# volume-set.ps1
# SKAPI WIN Display & Audio
# Sets the system master volume to a specific level (0-100). The clean
# Windows way is the Core Audio MMDevice / IAudioEndpointVolume COM API;
# this wrapper invokes it through inline C# Add-Type to avoid pulling
# in a third-party PowerShell module.
#
# Marked tier 2 in the manifest: the COM cast can fail on stripped-down
# Windows installs (Server Core, very old preview builds) and per-app
# audio devices may need a different endpoint. Tested on Windows 10/11
# desktop SKUs with the default render endpoint.

param(
  [int]$level = 50
)

if ($level -lt 0) { $level = 0 }
if ($level -gt 100) { $level = 100 }

$source = @"
using System;
using System.Runtime.InteropServices;

[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume {
    int RegisterControlChangeNotify(IntPtr p);
    int UnregisterControlChangeNotify(IntPtr p);
    int GetChannelCount(out uint c);
    int SetMasterVolumeLevel(float l, ref Guid g);
    int SetMasterVolumeLevelScalar(float l, ref Guid g);
    int GetMasterVolumeLevel(out float l);
    int GetMasterVolumeLevelScalar(out float l);
    int SetChannelVolumeLevel(uint i, float l, ref Guid g);
    int SetChannelVolumeLevelScalar(uint i, float l, ref Guid g);
    int GetChannelVolumeLevel(uint i, out float l);
    int GetChannelVolumeLevelScalar(uint i, out float l);
    int SetMute(bool m, ref Guid g);
    int GetMute(out bool m);
    int GetVolumeStepInfo(out uint s, out uint c);
    int VolumeStepUp(ref Guid g);
    int VolumeStepDown(ref Guid g);
    int QueryHardwareSupport(out uint m);
    int GetVolumeRange(out float min, out float max, out float inc);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
    int Activate(ref Guid id, int ctx, IntPtr a, [MarshalAs(UnmanagedType.IUnknown)] out object o);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
    int NotImplA();
    int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice ep);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumerator { }
public class Audio {
    public static void SetLevel(float scalar) {
        var enumerator = (IMMDeviceEnumerator)(new MMDeviceEnumerator());
        IMMDevice device;
        enumerator.GetDefaultAudioEndpoint(0, 1, out device);
        var iid = typeof(IAudioEndpointVolume).GUID;
        object o;
        device.Activate(ref iid, 7, IntPtr.Zero, out o);
        var v = (IAudioEndpointVolume)o;
        var g = Guid.Empty;
        v.SetMasterVolumeLevelScalar(scalar, ref g);
    }
}
"@

try {
  Add-Type -TypeDefinition $source
  [Audio]::SetLevel([float]$level / 100.0)
  Write-Output "Master volume set to $level%"
} catch {
  Write-Error $_.Exception.Message
  exit 1
}
