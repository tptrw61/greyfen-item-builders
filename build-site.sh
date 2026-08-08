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

# --- Greyfen campaign house rules -------------------------------------------
# Applied here rather than in the shared ../utopia sources, so the base Utopia
# builders stay rules-as-written and this change survives every rebuild.
#   * Item SP value is doubled.
VALUE_RE='const value = Math\.max(t\.rp \* tier\.multiplier, tier\.minValue);'
VALUE_NEW='const value = 2 * Math.max(t.rp * tier.multiplier, tier.minValue); /* Greyfen house rule: SP value doubled */'
GREYFEN_MARK='Greyfen house rule: SP value doubled'

for b in "${BUILDERS[@]}"; do
    src="$SRC_DIR/$b.html"
    dest="$DEST_DIR/$b.html"
    if [[ ! -f "$src" ]]; then
        echo "ERROR: source not found: $src" >&2
        exit 1
    fi
    sed -z -e 's#href="/"#href="../index.html"#' \
        -e 's#<head>\n<meta charset#<head>'"$FOUC"'\n<meta charset#' \
        -e 's#</head>\n<body>#'"$THEME_CSS"'\n<body>#' \
        -e 's#</body>\n</html>#'"$THEME_JS"'\n</html>#' \
        -e 's#'"$VALUE_RE"'#'"$VALUE_NEW"'#' \
        "$src" > "$dest"
    # Fail loudly if the house rule did not apply, rather than shipping base values.
    if ! grep -qF "$GREYFEN_MARK" "$dest"; then
        echo "ERROR: Greyfen SP-doubling patch did not apply to $dest." >&2
        echo "       The value computation in $src has probably changed upstream;" >&2
        echo "       update VALUE_RE in this script to match it." >&2
        exit 1
    fi
    echo "built $dest (SP doubled)"
done

echo "done"
