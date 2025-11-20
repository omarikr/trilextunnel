#!/bin/bash

TUNNEL_SERVER="tunnel.trilexhost.com"
TUNNEL_USER="tunneluser" 

echo "Searching for active tunnel to ${TUNNEL_SERVER}..."

# Find the SSH process that contains both the server name AND the tunnel user.
TUNNEL_INFO=$(ps aux | grep ssh | grep "$TUNNEL_SERVER" | grep "$TUNNEL_USER" | grep -v grep)

if [ -z "$TUNNEL_INFO" ]; then
    echo "❌ Tunnel not found. Please run the setup script first:"
    echo "curl -sL https://raw.githubusercontent.com/omarikr/trilextunnel/main/tunnel.sh | bash"
else
    # 🌟 NEW ROBUST PARSING METHOD 🌟
    # Use grep -oP (Perl regex) to find the digits located exactly between
    # ":0.0.0.0:" and ":localhost:22"
    ASSIGNED_PORT=$(echo "$TUNNEL_INFO" | grep -oP '0\.0\.0\.0:\K\d+(?=:localhost:22)')
    
    # Check if the extracted port is a valid number
    if ! [[ "$ASSIGNED_PORT" =~ ^[0-9]+$ ]]; then
        echo "⚠️ Found SSH tunnel process, but could not reliably extract the port number."
        echo "   The port extraction script failed. Please report this error."
    else
        echo "✅ Tunnel is active."
        echo "Assigned Port: ${ASSIGNED_PORT}"
        echo "Client SSH Command: ssh root@${TUNNEL_SERVER} -p ${ASSIGNED_PORT}"
    fi
fi
