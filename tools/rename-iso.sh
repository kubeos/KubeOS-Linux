#!/bin/sh
# KubeOS: drop live-build's ".hybrid" infix from the finished ISO name.
#
# RUN    sh tools/rename-iso.sh [build-dir]     (auto/build calls it after a successful build)
# WHY    live-build hard-codes the name of an iso-hybrid image as
#        "<image-name>-<arch>.hybrid.iso" (/usr/lib/live/build/binary_iso:30), and
#        that infix is an internal detail, not a file extension a user should
#        download: KubeOS ships "kubeos-<version>-<arch>.iso". Changing
#        --binary-image to "iso" would remove the infix but ALSO the MBR that
#        makes the image bootable from a USB stick, so the name is fixed up here
#        instead of in the configuration - the image itself is byte-identical,
#        only its name changes.
#        The companion .zsync embeds that file name in its text header
#        ("Filename:" and "URL:"), so it is renamed with it: the header lines are
#        rewritten and the binary block-checksum tail is copied through
#        untouched (verified byte-identical on a real 5.9 MB control file).
# SAFE   Re-runnable and harmless: with nothing to rename it exits 0, an already
#        renamed image is skipped, and every failure is a WARNING - it runs after
#        a finished build, so it must never turn a good ISO into a failed build.
set -eu

BUILD_DIR=${1:-.}
SUFFIX_OLD=".hybrid.iso"
SUFFIX_NEW=".iso"

log() { printf 'kubeos-rename: %s\n' "$*"; }
warn() { printf 'kubeos-rename: WARNING: %s\n' "$*" >&2; }

# Rewrite the text header of a .zsync file and rename it.
#   $1 old .zsync path  $2 old image name (as written in the header)
#   $3 new image name   $4 new .zsync path
# The header runs from line 1 to the first empty line; everything after it is
# binary block checksums that must not be touched, which is why the file is
# re-assembled with head(1) + tail -c instead of an in-place sed.
rewrite_zsync() {
    _src=$1
    _old=$2
    _new=$3
    _dst=$4

    _hdr_lines=$(awk '{ n++; if ($0 == "") { print n; exit } }' "$_src")
    if [ -z "$_hdr_lines" ]; then
        warn "$_src has no header terminator; leaving it alone"
        return 1
    fi

    _hdr_bytes=$(head -n "$_hdr_lines" "$_src" | wc -c)
    head -n "$_hdr_lines" "$_src" | sed "s|$_old|$_new|g" > "$_dst"
    tail -c "+$((_hdr_bytes + 1))" "$_src" >> "$_dst"

    if ! grep -qF -- "$_new" "$_dst"; then
        warn "$_dst does not mention $_new; leaving the control file alone"
        rm -f "$_dst"
        return 1
    fi
    log "${_src} -> ${_dst}"
}

cd "$BUILD_DIR"

for OLD in ./*"$SUFFIX_OLD"; do
    # No match at all: the glob stays literal, which is not an error.
    [ -e "$OLD" ] || continue

    BASE=${OLD#./}
    NEW=${BASE%"$SUFFIX_OLD"}$SUFFIX_NEW

    if [ -e "$NEW" ]; then
        warn "$NEW already exists; leaving $BASE alone"
        continue
    fi

    if ! mv -f "$OLD" "$NEW"; then
        warn "could not rename $BASE"
        continue
    fi
    log "$BASE -> $NEW"

    if [ -e "$BASE.zsync" ]; then
        if rewrite_zsync "$BASE.zsync" "$BASE" "$NEW" "$NEW.zsync"; then
            rm -f "$BASE.zsync"
        fi
    fi
done

exit 0
