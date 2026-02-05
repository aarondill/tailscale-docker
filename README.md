### How to use

1. Install Docker and docker-compose: [Instructions](https://docs.docker.com/engine/install/)
2. Run `docker-compose up -d`
3. Enable port forwarding for exit node

```shell
printf '%s\n' 'net.ipv4.ip_forward = 1' 'net.ipv6.conf.all.forwarding = 1' | sudo tee /etc/sysctl.d/99-tailscale.conf && sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
```

4. Go to [machines](https://login.tailscale.com/admin/machines) and select `Disable key expiry` next to the device!

## Local network

This configuration will allow you to use the local network when using exit node.
It does this by an undocumented hack where advertising routes that aren't approved work only when using exit node.
If you're not using the `10.0.0.0/25` subnet, change the value of `TS_ROUTES` in `compose.yaml` to your subnet.
If you want the subnet to be accessible anytime you are connected to the tailnet, be sure to approve the route in the UI.

## Pi Hole

If you're using Pi Hole, you can use the [DNS settings](https://login.tailscale.com/admin/dns) to route to the Pi Hole.

1. Copy the Tailscale IP from the Pi Hole [machine page](https://login.tailscale.com/admin/machines)
2. Set `Global nameservers` to the copied IP
   1. Add nameserver → custom
   2. Paste the copied IP
   3. Optionally `Use with exit node`
   4. Save
3. Enable `Override DNS servers` to make sure clients use the new DNS settings
