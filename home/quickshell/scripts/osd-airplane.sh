#!/usr/bin/env bash
# Toggles airplane mode (all radios) and shows the result in the OSD.
#
# Firmware mirror switches (e.g. ideapad_wlan) follow the real radios, so only
# the real devices decide the state. Overlapping key presses are ignored.

exec 9>"${XDG_RUNTIME_DIR:-/tmp}/osd-airplane.lock"
flock -n 9 || exit 0

# Soft-block state of every real radio, one per line: "blocked" / "unblocked"
radios() {
    rfkill -n -o DEVICE,SOFT 2>/dev/null | awk '$1 !~ /^ideapad_/ { print $2 }'
}

if radios | grep -qx "unblocked"; then
    rfkill block all
    want="blocked"
else
    rfkill unblock all
    want="unblocked"
fi

# Wait (up to ~2s) until every real radio reached the requested state
for _ in $(seq 20); do
    sleep 0.1
    radios | grep -qvx "$want" || break
done

if radios | grep -qx "unblocked"; then
    state="off"
else
    state="on"
fi

quickshell ipc call osd showAirplane "$state" >/dev/null 2>&1 || true
