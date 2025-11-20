#!/bin/bash

TUNNEL_SERVER="tunnel.trilexhost.com"
PORT_PATTERN=":0.0.0.0:"

echo "Searching for active tunnel to ${TUNNEL_SERVER}..."

# Find the SSH process that initiated the reverse tunnel (-R 0.0.0.0:PORT:...)
# The output will look like: ssh -i ... -R 0.0.0.0:3456:localhost:22 ...
TUNNEL_INFO=$(ps aux | grep ssh | grep "$TUNNEL_SERVER" | grep "$PORT_PATTERN" | grep -v grep)

if [ -z "$TUNNEL_INFO" ]; then
    echo "❌ Tunnel not found. Please run the setup script first:"
    echo "curl -sL https://raw.githubusercontent.com/omarikr/trilextunnel/main/tunnel.sh | bash"
else
    # Extract the port number which is between ":0.0.0.0:" and ":localhost:22"
    ASSIGNED_PORT=$(echo "$TUNNEL_INFO" | awk -F':0.0.0.0:' '{print $2}' | awk -F':localhost:22' '{print $1}')
    
    echo "✅ Tunnel is active."
    echo "Assigned Port: ${ASSIGNED_PORT}"
    echo "Client SSH Command: ssh root@${TUNNEL_SERVER} -p ${ASSIGNED_PORT}"
fi
