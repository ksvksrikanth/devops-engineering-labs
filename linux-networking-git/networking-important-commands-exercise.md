# Networking Important Commands Exercise

This exercise walks through common networking commands used in Linux and DevOps troubleshooting: checking IP addresses, routes, DNS, connectivity, ports, sockets, HTTP responses, and packet paths.

Run these commands in a Linux terminal such as Ubuntu, WSL, or an EC2 Linux instance.

## 1. Check Hostname and IP Addresses

Show the hostname:

```bash
# Purpose: Print the system hostname.
hostname
```

Show all network interfaces and IP addresses:

```bash
# Purpose: Show all network interfaces and assigned IP addresses.
ip address
```

Short form:

```bash
# Purpose: Show all network interfaces and IP addresses using the short command form.
ip a
```

Show only IPv4 addresses:

```bash
# Purpose: Show only IPv4 addresses.
ip -4 address
```

## 2. Check Default Gateway and Routes

Show the routing table:

```bash
# Purpose: Display the kernel routing table.
ip route
```

Show the default route:

```bash
# Purpose: Show the default gateway route.
ip route | grep default
```

## 3. Test Network Connectivity

Ping a public DNS resolver:

```bash
# Purpose: Test raw IP connectivity without depending on DNS.
ping -c 4 8.8.8.8
```

Ping a domain name:

```bash
# Purpose: Test both network connectivity and DNS resolution.
ping -c 4 google.com
```

If the IP ping works but the domain ping fails, suspect DNS resolution.

## 4. Check DNS Resolution

Resolve a domain with `nslookup`:

```bash
# Purpose: Resolve a domain name using the configured DNS resolver.
nslookup google.com
```

Resolve a domain with `dig`:

```bash
# Purpose: Query DNS records for a domain.
dig google.com
```

Query a specific DNS server:

```bash
# Purpose: Query a specific DNS server directly.
dig @8.8.8.8 google.com
```

Check configured DNS servers:

```bash
# Purpose: Inspect DNS resolver configuration.
cat /etc/resolv.conf
```

## 5. Test HTTP and HTTPS

Fetch only response headers:

```bash
# Purpose: Fetch only HTTP response headers.
curl -I https://www.google.com
```

Fetch a page body:

```bash
# Purpose: Fetch the HTTP response body.
curl https://www.google.com
```

Show detailed connection information:

```bash
# Purpose: Show detailed HTTP, TLS, and connection diagnostics.
curl -v https://www.google.com
```

Save output to a file:

```bash
# Purpose: Save the HTTP response body to google.html.
curl -o google.html https://www.google.com
```

## 6. Check Listening Ports

Show listening TCP and UDP sockets:

```bash
# Purpose: Show listening TCP and UDP sockets without resolving names.
ss -tuln
```

Show listening sockets with process details:

```bash
# Purpose: Show listening sockets with process details.
sudo ss -tulnp
```

Filter for SSH port 22:

```bash
# Purpose: Find the process listening on SSH port 22.
sudo ss -tulnp | grep ':22'
```

## 7. Check Open Connections

Show active TCP connections:

```bash
# Purpose: Show all TCP socket states.
ss -tan
```

Show established connections:

```bash
# Purpose: Show only established TCP connections.
ss -tan state established
```

## 8. Trace Network Path

Trace the path to a domain:

```bash
# Purpose: Trace the network path to a destination.
traceroute google.com
```

If `traceroute` is not installed:

```bash
# Purpose: Refresh apt package metadata before installing traceroute.
sudo apt-get update
# Purpose: Install traceroute when it is missing.
sudo apt-get install -y traceroute
```

Alternative command:

```bash
# Purpose: Trace the path to a destination using tracepath.
tracepath google.com
```

## 9. Test a Specific Port

Use `nc` to test if a TCP port is reachable:

```bash
# Purpose: Test whether TCP port 443 is reachable on google.com.
nc -vz google.com 443
```

Install `nc` if needed:

```bash
# Purpose: Refresh apt package metadata before installing netcat.
sudo apt-get update
# Purpose: Install netcat for TCP port testing.
sudo apt-get install -y netcat-openbsd
```

Test SSH locally:

```bash
# Purpose: Test whether local SSH port 22 is reachable.
nc -vz localhost 22
```

## 10. Download Files

Download a file with `wget`:

```bash
# Purpose: Download a page or file with wget.
wget https://example.com
```

Download with `curl`:

```bash
# Purpose: Download a remote file using curl and keep its remote filename.
curl -O https://example.com
```

## 11. Inspect Firewall Status

Check UFW status:

```bash
# Purpose: Check the current UFW firewall status.
sudo ufw status
```

Allow SSH through UFW:

```bash
# Purpose: Allow inbound SSH traffic through UFW.
sudo ufw allow ssh
```

Allow HTTP:

```bash
# Purpose: Allow inbound HTTP traffic through UFW.
sudo ufw allow 80/tcp
```

Only enable or modify firewall rules when you understand the access impact, especially on remote servers.

## 12. Useful Troubleshooting Flow

Use this order when debugging connectivity:

```bash
# Purpose: Check local interface addresses.
ip a
# Purpose: Check default gateway and routes.
ip route
# Purpose: Check configured DNS resolvers.
cat /etc/resolv.conf
# Purpose: Test IP connectivity.
ping -c 4 8.8.8.8
# Purpose: Test DNS and connectivity together.
ping -c 4 google.com
# Purpose: Resolve a DNS name.
nslookup google.com
# Purpose: Check HTTP response headers.
curl -I https://google.com
# Purpose: Check listening ports and related processes.
ss -tulnp
# Purpose: Trace packet path to the destination.
traceroute google.com
```

## Cleanup

Remove downloaded test files if you created them:

```bash
# Purpose: Remove downloaded test files from the exercise.
rm -f google.html index.html
```

## Safety Notes

- Use `sudo` only when process details, package installation, or firewall changes require it.
- Be careful when changing firewall rules on remote systems.
- `ping`, `curl`, and DNS results vary by network, VPN, proxy, firewall, and cloud security group settings.
