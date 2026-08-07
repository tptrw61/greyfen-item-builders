#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

SRC_DIR="${SRC_DIR:-../utopia/item-gen}"
DEST_DIR="item-gen"
BUILDERS=(weapon-builder chest-armor-builder shield-builder head-armor-builder hand-armor-builder foot-armor-builder)

mkdir -p "$DEST_DIR"
touch .nojekyll

FOUC='<script>document.documentElement.setAttribute("data-theme", localStorage.getItem("utopia-theme") || "dark");</script>'
THEME_CSS='<link rel="stylesheet" href="../theme.css">'
THEME_JS='<script src="../theme.js"></script>'

for b in "${BUILDERS[@]}"; do
    src="$SRC_DIR/$b.html"
    dest="$DEST_DIR/$b.html"
    if [[ ! -f "$src" ]]; then
        echo "ERROR: source not found: $src" >&2
        exit 1
    fi
    sed -e 's#href="/"#href="../index.html"#' \
        -e "s#<head>#<head>$FOUC#" \
        -e "s#</head>#$THEME_CSS</head>#" \
        -e "s#</body>#$THEME_JS</body>#" \
        "$src" > "$dest"
    echo "built $dest"
done

echo "done"
