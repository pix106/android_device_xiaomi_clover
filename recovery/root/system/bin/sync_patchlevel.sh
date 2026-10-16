#!/system/bin/sh
#
# Align the recovery image header (os_version / os_patch_level) with the
# installed ROM.
#
# On clover the bootloader hands the values from the header of the booted
# image to the QTI keymaster 3.0 TA. The keymaster HAL later reports the ROM's
# values (set by prepdecrypt), and the TA rejects configure() with
# KM_ERROR_INVALID_ARGUMENT (-38) if they differ. Decryption then hangs.
#
# If the header differs from the ROM, rewrite it, flash it back to the
# recovery partition and reboot into recovery once. The values are copied
# exactly from the ROM, never raised, so the ROM's key blobs are never
# upgraded.

TAG=sync_patchlevel
REC=/dev/block/bootdevice/by-name/recovery
SYS=/dev/block/bootdevice/by-name/system
WORK=/tmp/sync_patchlevel
MNT=$WORK/system
MB=/system/bin/magiskboot

log() { /system/bin/log -p i -t "$TAG" "$*"; echo "I:$TAG: $*" >> /tmp/recovery.log; }
die() { log "$*"; cleanup; exit 0; }
cleanup() {
	umount "$MNT" 2>/dev/null
	cd /
	rm -rf "$WORK"
}

# The keymaster HAL may read the Android version / patch level from any of
# these properties. The recovery build leaves most of them at its placeholder
# values (99.87.36 / 2127-12-31), so the HAL could report a different OS
# version to the TA than the ROM did when it created its keys. Set them all to
# the ROM's values before keymaster starts.
set_version_props() {
	RP=/system/bin/resetprop
	[ -x "$RP" ] || { log "resetprop not found, version props left unchanged"; return; }
	for p in ro.build.version.release ro.build.version.release_or_codename \
		ro.build.version.release_or_preview_display \
		ro.system.build.version.release ro.system.build.version.release_or_codename \
		ro.system_ext.build.version.release ro.system_ext.build.version.release_or_codename \
		ro.vendor.build.version.release ro.vendor.build.version.release_or_codename \
		ro.odm.build.version.release ro.odm.build.version.release_or_codename \
		ro.bootimage.build.version.release ro.bootimage.build.version.release_or_codename; do
		$RP -n "$p" "$REL_RAW"
	done
	for p in ro.build.version.security_patch ro.vendor.build.security_patch; do
		$RP -n "$p" "$SPL_RAW"
	done
	log "version props set to $REL_RAW / $SPL_RAW"
}

[ -x "$MB" ] || { log "magiskboot not found, skipping"; exit 0; }
[ -b "$REC" ] || { log "no recovery partition, skipping"; exit 0; }

rm -rf "$WORK"
mkdir -p "$MNT" || exit 0

# Read the ROM's Android version and security patch level
mount -t ext4 -o ro "$SYS" "$MNT" 2>/dev/null || die "cannot mount system, skipping"
PROP=$MNT/system/build.prop
[ -f "$PROP" ] || PROP=$MNT/build.prop
[ -f "$PROP" ] || die "no build.prop (no ROM installed?), skipping"
REL=$(grep -m1 '^ro.build.version.release=' "$PROP" | cut -d= -f2)
SPL=$(grep -m1 '^ro.build.version.security_patch=' "$PROP" | cut -d= -f2)
umount "$MNT"
REL_RAW=$REL
SPL_RAW=$SPL

# Normalise: "16" -> "16.0.0", "2026-09-01" -> "2026-09"
case "$REL" in
	*.*.*) ;;
	*.*) REL="$REL.0" ;;
	*) REL="$REL.0.0" ;;
esac
SPL=$(echo "$SPL" | cut -c1-7)
echo "$REL" | grep -qE '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' || die "unusable ROM version '$REL', skipping"
echo "$SPL" | grep -qE '^20[0-9]{2}-[01][0-9]$' || die "unusable ROM patch level '$SPL', skipping"

# Read the current recovery image header
cd "$WORK" || die "cannot enter $WORK"
dd if="$REC" of=rec.img bs=1M 2>/dev/null || die "cannot read recovery partition"
$MB unpack -h rec.img >/dev/null 2>&1 || die "magiskboot unpack failed, skipping"
[ -f header ] || die "no header dumped, skipping"
CUR_VER=$(grep -m1 '^os_version=' header | cut -d= -f2)
CUR_SPL=$(grep -m1 '^os_patch_level=' header | cut -d= -f2)
log "ROM: $REL / $SPL, recovery header: $CUR_VER / $CUR_SPL"

if [ "$CUR_VER" = "$REL" ] && [ "$CUR_SPL" = "$SPL" ]; then
	log "header already matches the ROM"
	set_version_props
	cleanup
	exit 0
fi

# Rewrite the header and repack
sed -i -e "s/^os_version=.*/os_version=$REL/" -e "s/^os_patch_level=.*/os_patch_level=$SPL/" header
$MB repack rec.img new.img >/dev/null 2>&1 || die "magiskboot repack failed, leaving recovery untouched"

# Verify the new image before touching the partition
mkdir check && cd check || die "cannot create check dir"
$MB unpack -h ../new.img >/dev/null 2>&1 || die "repacked image unreadable, leaving recovery untouched"
NEW_VER=$(grep -m1 '^os_version=' header | cut -d= -f2)
NEW_SPL=$(grep -m1 '^os_patch_level=' header | cut -d= -f2)
cd ..
[ "$NEW_VER" = "$REL" ] && [ "$NEW_SPL" = "$SPL" ] || die "repacked header is '$NEW_VER / $NEW_SPL', leaving recovery untouched"
PART_SIZE=$(blockdev --getsize64 "$REC")
IMG_SIZE=$(stat -c %s new.img)
[ "$IMG_SIZE" -le "$PART_SIZE" ] || die "new image too large ($IMG_SIZE > $PART_SIZE), leaving recovery untouched"

dd if=new.img of="$REC" bs=1M conv=fsync 2>/dev/null || die "writing recovery partition FAILED"
sync
log "recovery header updated to $REL / $SPL, rebooting into recovery"
cleanup
setprop sys.powerctl reboot,recovery
sleep 10
