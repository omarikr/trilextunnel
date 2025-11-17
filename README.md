🚀 TrilexHost VPS Connectivity Service (IPv6 Tunnel)
This repository provides a single-command script to establish a secure, temporary IPv4 connection to your TrilexHost non-IPv4 (likely IPv6-only or internal DHCP) VPS. This solution ensures all your clients can reliably SSH into their containers using a standard public IPv4 address and port.

💡 How It Works
The service is based on an SSH Reverse Tunnel facilitated by our central Tunnel Server (tunnel.trilexhost.com).

A client runs the curl command on their VPS.

The script generates a unique, random public port on our Tunnel Server.

It initiates a Reverse SSH Tunnel using a highly restricted key to connect to our Tunnel Server.

The Tunnel Server then exposes the client's internal SSH port (22) to the internet via that unique public port.

The client receives the final, public SSH command needed to connect. The tunnel connects to localhost:22 inside the VPS, ensuring compatibility with DHCP/shared IP environments.

🛠️ Usage Instructions
1. Run the Command on Your VPS
To activate your temporary tunnel, execute the following command as the root user on your TrilexHost VPS:

Bash

curl -sL https://raw.githubusercontent.com/omarikr/trilextunnel/main/tunnel.sh | bash
2. Connect Using the Output
The script will successfully output the exact command you need for your final SSH connection.

Example Output:

✅ Tunnel established successfully!
Client SSH Command:
ssh root@tunnel.trilexhost.com -p 24567
Use the outputted command to log in to your VPS from any external network.

⚠️ Important Notes
Persistence: The tunnel process runs in the background. If the VPS reboots or the tunnel process is killed, you must run the initial curl command again to re-establish the connection and get a new port.

Security: This service uses a dedicated, non-shell user (tunneluser) and a dedicated SSH key for connection. This limits the ability of a compromised client VPS to interact with our central Tunnel Server.

Compatibility: This method works universally for VPSes, whether they use DHCP, shared IPv4, or an internal IPv6 address for their main network interface.

📞 Support
If you experience "Permission Denied" or "Connection Refused" errors, first try running the setup command again. If the issue persists, please contact TrilexHost support with your VPS details.
