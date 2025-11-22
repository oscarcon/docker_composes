wget \
  https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.0.1.linux-amd64.tar.gz
mv node_exporter-1.0.1.linux-amd64 node_exporter-files
sudo cp node_exporter-files/node_exporter /usr/bin/

sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOT
[Unit]
Description=Node Exporter
Documentation=https://prometheus.io/docs/guides/node-exporter/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
Restart=on-failure
ExecStart=
ExecStart=/usr/bin/node_exporter \
  --web.listen-address=:9100 \
  --collector.textfile.directory=/var/lib/node-exporter

[Install]
WantedBy=multi-user.target
EOT

sudo mkdir -p /var/lib/node-exporter
sudo tee /var/lib/node-exporter/node.prom > /dev/null << EOT
node{node="$(hostname)"} 1
EOT

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter.service
