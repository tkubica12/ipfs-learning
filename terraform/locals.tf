locals {
  base_name        = "${replace(var.prefix, "_", "-")}-${random_string.main.result}"
  base_name_nodash = replace(local.base_name, "-", "")

  install_script = <<SCRIPT
#!/bin/bash
# Install desktop and RDP
apt update
apt upgrade -y
export DEBIAN_FRONTEND=noninteractive
sudo apt install ubuntu-desktop -y
apt install -y xrdp
adduser xrdp ssl-cert
systemctl restart xrdp
sudo systemctl restart xrdp
sudo systemctl enable xrdp

# Install IPFS
wget https://github.com/ipfs/kubo/releases/download/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz
tar -xvf kubo_v0.29.0_linux-amd64.tar.gz
mv kubo/ipfs /usr/local/bin/ipfs
rm -rf kubo
rm kubo_v0.29.0_linux-amd64.tar.gz

# Check version
ipfs --version

# Initialize IPFS
ipfs init

# Create systemd service file for IPFS
cat <<EOF > /etc/systemd/system/ipfs.service
[Unit]
Description=IPFS Daemon
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/ipfs daemon --migrate=true
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start IPFS service
systemctl enable ipfs
systemctl start ipfs
SCRIPT
}