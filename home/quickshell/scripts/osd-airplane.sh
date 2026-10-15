#!/usr/bin/env bash
# TO DO FIX!!!

exec 9>"${XDG_RUNTIME_DIR:-/tmp}/osd-airplane.lock"
flock -n 9 || exit 0

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
