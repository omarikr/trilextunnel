#!/bin/bash

# --- Configuration ---
TUNNEL_SERVER="tunnel.trilexhost.com"  
TUNNEL_USER="tunneluser"
CLIENT_KEY_FILE=$(mktemp)

# --- 1. Embed the Private Key ---
# (Ensure your Private Key is fully pasted here)
cat << 'EOT' > "$CLIENT_KEY_FILE"
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCbKLChHyitTrW54XoFgJ5Qj9CbZXumJMKEn/acP5qkqwAAAJCLhYpCi4WK
QgAAAAtzc2gtZWQyNTUxOQAAACCbKLChHyitTrW54XoFgJ5Qj9CbZXumJMKEn/acP5qkqw
AAAECAU3AWFD0RPEZ6zn9isURtKV9W0VdHgHpapepfail8DpsosKEfKK1OtbnhegWAnlCP
0Jtle6YkwoSf9pw/mqSrAAAAB0hQQE9tYXIBAgMEBQY=
-----END OPENSSH PRIVATE KEY-----
EOT

# Ensure permissions are secure for the key file
chmod 600 "$CLIENT_KEY_FILE"

# --- 2. Generate Port and Start Tunnel ---
# Generates a random port between 3000 and 3999
CLIENT_PORT=$((3000 + RANDOM % 1000))

echo "Attempting to establish tunnel to ${TUNNEL_SERVER} on port ${CLIENT_PORT}..."

ssh -i "$CLIENT_KEY_FILE" -f -N -T \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=60 -o ServerAliveCountMax=3 \
    -o StrictHostKeyChecking=no \
    -R 0.0.0.0:${CLIENT_PORT}:localhost:22 \
    ${TUNNEL_USER}@${TUNNEL_SERVER}

# --- 3. Cleanup and Output ---
if [ $? -eq 0 ]; then
    echo "✅ Tunnel established successfully!"
    echo "Client SSH Command: ssh root@${TUNNEL_SERVER} -p ${CLIENT_PORT}"
else
    echo "❌ Failed to establish the tunnel. Connection failed or port is in use."
fi

# Remove the temporary private key file
rm "$CLIENT_KEY_FILE"
