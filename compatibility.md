# Compatibility of OnePlus Kernels
## OnePlus 13 Global source baseline

The current published Global build remains based on the matching official
OnePlusOSS **16.0.9.401(EX01)** source pair. Its selected config is
`configs/oos16/OP13-GLOBAL-6.6.118.json` with **Linux 6.6.118 / android15 KMI**.
The synchronization commits explicitly list CPH2649 and CPH2653; they do not
establish support for CPH2655 on this source release.

**ColorOS 17 / Android 17 for CPH2653 EU/GLO is the next target.** It is not
marked build-compatible merely because the firmware is available. A ColorOS 17
release requires matching official OnePlusOSS common-kernel and
modules/device-tree revisions for the same CPH2653 release, verification of the
actual KMI/Linux version, and a compatible BakaSU + SUSFS pair. As checked on
2026-11-03, that official CPH2653 17.x source pair is still missing, so the
existing OxygenOS kernel must not be relabeled as a ColorOS 17 build.

See [ColorOS 17 migration status](docs/op13-coloros17-migration.md) and the
[OxygenOS 16 source evidence](docs/op13-upstream-update.md).

## 1. OnePlus Devices

<table>
  <tr>
    <th> :warning: </th>
    <th> All the Kernels are built on <a href="https://github.com/OnePlusOSS/">OnePlus Official Source</a> and are expected to work only on Stock roms!!!</th>
  </tr>
</table>

 - Currently All the kernels are built from Android 15 Manifest.
 - Do not use the zips after Major Android OTA (a15 -> a16) unless its verified in <a href="https://t.me/huangdihd_wildkernel">WildKernels</a> Telegram group or other sources like XDA.

## 2. Non-OnePlus Devices
### List of verified devices 
<table>
  <tr>
    <th> :warning: </th>
    <th> We expect all users who wants to test OnePlus Kernels on Non-OnePlus Phones to first disable dm-verity and verification using fastboot or other means.</th>
  </tr>
</table>

 - If your device is not in list, please select the device which is most similar and matches the kernel version (androidXX-YY.ZZ.AAA). AAA must be atleast same or greater. XX-YY.ZZ must match exactly. More Information on this can be read @<a href="https://kernelsu.org/guide/installation.html#kmi">KernelSU.org</a>.
 - Thanks to our community users at <a href="https://t.me/huangdihd_wildkernel">WildKernels</a> for helping us compile the list.
 - We request more users come forward help us keep the list updated. 
 - I'm sure more devices from other brands are also supported.
<table>
	<tr> 
		<th align="center"> Device Name </th>
		<th align="center"> Working Kernel Device Name </th>
	    <th align="center"> Current Kernel Version </th>
	</tr>
	<tr> 
		<td align="center"> Poco X7 Pro(used to work before)<br>Realme GT 7 Pro </td>
		<td align="center"> OnePlus 13<br>OnePlus Ace 5 Pro </td>
		<td align="center"> android15-6.6.89<br>android15-6.6.89 </td>
	</tr>
	<tr> 
		<td align="center"> Realme GT Neo 5SE<br>Realme GT Neo 5 </td>
		<td align="center"> OnePlus 10T<br>OnePlus 10 Pro<br>OnePlus Ace 2<br>OnePlus 11r (Partially) </td>
		<td align="center"> android12-5.10.226<br>android12-5.10.226<br>android12-5.10.226<br>android12-5.10.209 </td>
	</tr>
	<tr> 
		<td align="center"> Realme GT 5<br>Poco F6 Pro </td>
		<td align="center"> OnePlus 11<br>OnePlus 11 </td>
		<td align="center"> android13-5.15.167<br>android13-5.15.180 </td>
	</tr>
	<tr> 
		<td align="center"> Realme GT Neo 6SE<br>Realme GT Neo 6T </td>
		<td align="center"> OnePlus Nord 4 </td>
		<td align="center"> android14-6.1.118 </td>
	</tr>
	<tr> 
		<td align="center"> Realme GT 2 Pro </td>
		<td align="center"> OnePlus 10 Pro </td>
		<td align="center"> android12-5.10.226 </td>
	</tr>
	<tr> 
		<td align="center"> Poco F8 Ultra </td>
		<td align="center"> OnePlus 15 </td>
		<td align="center"> android16-6.12.23 </td>
	</tr>
	<tr> 
		<td align="center"> MI 12T Pro </td>
		<td align="center"> OnePlus 10T</td>
		<td align="center"> android12-5.10.226<br>android12-5.10.236</td>
	</tr>
	<tr> 
		<td align="center"> Realme GT5 Pro </td>
		<td align="center"> OnePlus 12 </td>
		<td align="center"> android14-6.1.118 </td>
	</tr>
</table>
