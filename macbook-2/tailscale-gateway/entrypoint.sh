#!/bin/sh
# Tailscale "personal tailnet" gateway.
#   - joins the personal tailnet (auth key mounted at /run/authkey, from SOPS)
#   - NATs all traffic arriving on eth0 (from the macOS host) to one target
#     node on the personal tailnet, so the host can reach it transparently
#     while its native Tailscale client stays on the WORK tailnet.
set -eu

STATE_DIR=/var/lib/tailscale
SOCK=/var/run/tailscale/tailscaled.sock
HOSTNAME_TS="${TS_HOSTNAME:-macbook-personal-gw}"
TARGET="${DNAT_TARGET:?DNAT_TARGET must be set (target node IP on personal tailnet)}"

mkdir -p "$STATE_DIR" /var/run/tailscale

echo "[gw] starting tailscaled..."
tailscaled --state="$STATE_DIR/tailscaled.state" --socket="$SOCK" --tun=tailscale0 &
TS_PID=$!

# wait for the control socket
for _ in $(seq 1 40); do [ -S "$SOCK" ] && break; sleep 0.5; done

# Auth key only needed for first registration; persistent state covers restarts.
AUTH=""
[ -f /run/authkey ] && AUTH="$(cat /run/authkey 2>/dev/null || true)"
[ -n "${TS_AUTHKEY:-}" ] && AUTH="$TS_AUTHKEY"

if [ -n "$AUTH" ]; then
  echo "[gw] tailscale up (with auth key)"
  tailscale up --authkey="$AUTH" --hostname="$HOSTNAME_TS" --accept-dns=false
else
  echo "[gw] tailscale up (using existing persisted state)"
  tailscale up --hostname="$HOSTNAME_TS" --accept-dns=false
fi

echo "[gw] tailnet IP: $(tailscale ip -4 2>/dev/null || echo '?')"

echo "[gw] enabling IP forwarding + DNAT -> $TARGET"
# ip_forward is set via compose `sysctls` at creation; this runtime write is
# best-effort (some container runtimes mount /proc/sys read-only).
echo 1 > /proc/sys/net/ipv4/ip_forward 2>/dev/null || echo "[gw] (ip_forward already set via sysctl)"
iptables -t nat -F PREROUTING
iptables -t nat -A PREROUTING -i eth0 -j DNAT --to-destination "$TARGET"
iptables -t nat -A POSTROUTING -o tailscale0 -j MASQUERADE

echo "[gw] READY — host traffic to this container is forwarded to $TARGET over the personal tailnet"
wait "$TS_PID"
