#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! $1 =~ ^[0-9]{8}$ ]]; then
    printf 'Usage: %s yyyymmdd\n' "${0##*/}" >&2
    exit 2
fi

release_date=$1
base_url="https://lv1.sh/api/download/$release_date"

if ! command -v curl >/dev/null 2>&1; then
    printf 'Error: curl is required to download files.\n' >&2
    exit 1
fi

artifacts=(
    "clibs/kdbcapi-linux.so"
    "clibs/kdbcapi-mac.so"
    "clibs/libl_parquet-linux.so"
    "clibs/libl_parquet-mac.so"
    "lin-avx2/l_l64"
    "lin-avx512/l_l64"
    "lin-oxide/l_l64"
    "osx-arm64/l_m64"
)

for artifact in "${artifacts[@]}"; do
    destination="$release_date/$artifact"
    mkdir -p "$(dirname "$destination")"
    curl --fail --location --show-error \
        --output "$destination" \
        "$base_url/$artifact"
done

chmod +x \
    "$release_date/lin-avx2/l_l64" \
    "$release_date/lin-avx512/l_l64" \
    "$release_date/osx-arm64/l_m64"
