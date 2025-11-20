#!/bin/bash

TUNNEL_SERVER="tunnel.trilexhost.com"
# The client script runs the tunnel using the 'tunneluser'
TUNNEL_USER="tunneluser" 

echo "Searching for active tunnel to ${TUNNEL_SERVER}..."

# Find the SSH process that contains both the server name AND the tunnel user.
# The crucial part of the process line we want is '-R 0.0.0.0:3543:localhost:22'
TUNNEL_INFO=$(ps aux | grep ssh | grep "$TUNNEL_SERVER" | grep "$TUNNEL_USER" | grep -v grep)

if [ -z "$TUNNEL_INFO" ]; then
    echo "❌ Tunnel not found. Please run the setup script first:"
    echo "curl -sL https://raw.githubusercontent.com/omarikr/trilextunnel/main/tunnel.sh | bash"
else
    # Extract the port number. The port is the number between ":0.0.0.0:" and ":localhost:22"
    # We use a robust way to extract the numbers between those delimiters.
    ASSIGNED_PORT=$(echo "$TUNNEL_INFO" | awk -F':0.0.0.0:' '{print $2}' | awk -F':localhost:22' '{print $1}' | tr -d '[:space:]')
    
    # Check if the extracted port is a valid number
    if ! [[ "$ASSIGNED_PORT" =~ ^[0-9]+$ ]]; then
        echo "⚠️ Found SSH tunnel process, but could not reliably extract the port number."
        echo "   Please stop and restart the tunnel setup."
    else
        echo "✅ Tunnel is active."
        echo "Assigned Port: ${ASSIGNED_PORT}"
        echo "Client SSH Command: ssh root@${TUNNEL_SERVER} -p ${ASSIGNED_PORT}"
    fi
fi
