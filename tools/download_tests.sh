#!/usr/bin/env bash
# download the Z80 test roms
# set -x

URL="https://mdfs.net/Software/Z80/Exerciser/CPM.zip"
IS_DOWNLOADED=0
OUTDIR="$1"

[ -z "$OUTDIR" ] && {
    echo "${0##*/} <output-dir> - download Z80 test roms"
    exit 1
}

mkdir -p "$OUTDIR"

if [ -d "$OUTDIR" ]; then
    if [ -f "$OUTDIR/zexall.com" ] && [ -f "$OUTDIR/zexdoc.com" ]; then
        IS_DOWNLOADED=1
    fi
fi

if [ ! "$IS_DOWNLOADED" -eq 1 ]; then
    if ! wget "$URL"; then
        echo "wget failure for '$URL'"
        exit 1
    fi

    if ! unzip -o -d "$OUTDIR" CPM.zip; then
        echo "zip failure for '$OUTDIR'"
        exit 1
    fi

    cleanup=(
        CPM.zip
        CPM.zip.1
        CPM.zip.2
        CPM.zip.3
        CPM.zip.4
    )

    for part in "${cleanup[@]}"; do
        [ -f "$part" ] && rm "$part"
    done

    exit 0
else
    exit 0
fi
