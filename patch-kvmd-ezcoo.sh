#!/usr/bin/env bash
# patch-kvmd-ezcoo.sh  -- run with: sudo ./patch-kvmd-ezcoo.sh
set -euo pipefail

COMMIT_URL="https://github.com/semool/kvmd/commit/b9fd5b03dfe4b4500ac26c0685ae9fc4c908ca8a.patch"
PY_BASE="/usr/lib/python3.14/site-packages"     # contains kvmd/
WEB_BASE="/usr/share/kvmd"                       # contains web/  (verify, see below)

command -v git  >/dev/null || { echo "Install git:  apt install git"; exit 1; }
command -v curl >/dev/null || { echo "Install curl: apt install curl"; exit 1; }

[[ -d "$PY_BASE/kvmd" ]]                     || { echo "Not found: $PY_BASE/kvmd"; exit 1; }
[[ -f "$WEB_BASE/web/share/js/kvm/gpio.js" ]] || { echo "Not found: $WEB_BASE/web/share/js/kvm/gpio.js
Find it with: find / -name gpio.js -path '*kvm*' 2>/dev/null"; exit 1; }

PATCH="$(mktemp --suffix=.patch)"
trap 'rm -f "$PATCH"' EXIT
curl -fsSL "$COMMIT_URL" -o "$PATCH"

STAMP="$(date +%Y%m%d-%H%M%S)"
tar -czf "/root/kvmd-py-backup-$STAMP.tar.gz"  -C "$PY_BASE"  kvmd
tar -czf "/root/kvmd-web-backup-$STAMP.tar.gz" -C "$WEB_BASE" web
echo "Backups saved in /root/ (*-$STAMP.tar.gz)"

# Dry-run BOTH parts before changing anything
(cd "$PY_BASE"  && git apply --check -p1 --include='kvmd/*' "$PATCH")
(cd "$WEB_BASE" && git apply --check -p1 --include='web/*'  "$PATCH")
echo "Dry runs OK, applying..."

(cd "$PY_BASE"  && git apply -v -p1 --include='kvmd/*' "$PATCH")
(cd "$WEB_BASE" && git apply -v -p1 --include='web/*'  "$PATCH")

find "$PY_BASE/kvmd" -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true
echo "Done. Now restart:  systemctl restart kvmd"
