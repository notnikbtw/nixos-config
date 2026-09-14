#!/usr/bin/env bash
set -euo pipefail

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
QR_PNG="$RUNTIME_DIR/wifi-qr.png"

ACTIVE_LINE=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep "^yes:" | head -n 1 || true)
SSID="${ACTIVE_LINE#yes:}"

if [[ -z "$SSID" ]]; then
    echo '{"error":"No active Wi-Fi connection"}'
    exit 0
fi

PROFILE=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active 2>/dev/null | grep ":802-11-wireless:" | head -n 1 | cut -d: -f1 || true)
PSK=""
if [[ -n "$PROFILE" ]]; then
    PSK=$(nmcli -s -g 802-11-wireless-security.psk connection show "$PROFILE" 2>/dev/null || true)
fi

if [[ -z "$PSK" ]]; then
    PAYLOAD="WIFI:T:nopass;S:$SSID;;"
else
    PAYLOAD="WIFI:T:WPA;S:$SSID;P:$PSK;;"
fi

if command -v qrencode >/dev/null 2>&1; then
    qrencode -o "$QR_PNG" -s 8 "$PAYLOAD" || true
fi

jq -c -n \
  --arg ssid "$SSID" \
  --arg psk "$PSK" \
  --arg path "$QR_PNG" \
  '{ssid: $ssid, psk: $psk, qrPath: $path}'

