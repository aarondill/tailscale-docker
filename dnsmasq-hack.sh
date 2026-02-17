#!/bin/sh

# Set the subnet so that dnsmasq properly localises. This is a hack that is explicitly unsupported by Tailscale.
# See https://github.com/tailscale/tailscale/issues/7340

set -eu
# wait until tailscaled is up
until tailscale status >/dev/null 2>&1; do
  sleep 2
done

# If pi-hole or dnsmasq is not running, we don't need to do anything; just keep checking every once in a while
until pgrep dnsmasq >/dev/null || pgrep pihole-FTL >/dev/null; do
  sleep 30
done

setmask() {
  echo "$0: Setting netmask"
  # Note that this will have issues if you're using CGNAT
  ifconfig tailscale0 netmask 255.192.0.0 || true
}
# run once for initial config
setmask
while true; do
  if ip monitor dev tailscale0 | head -n1 | grep "^deleted"; then
    continue # skip if the interface is deleted (tailscale down)
  fi
  setmask
done
