#cloud-config
users:
  - name: eric
    ssh-authorized-keys:
      - ${ssh_authorized_key}
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: sudo
    shell: /bin/bash
packages:
  - curl
  - git
mounts:
  - [
      "LABEL=${home_volume_label}",
      "/home/eric",
      "auto",
      "defaults,uid=1000,gid=1000"
    ]
write_files:
  - path: /opt/coder/init
    permissions: "0755"
    encoding: b64
    content: ${init_script}
  - path: /etc/systemd/system/coder-agent.service
    permissions: "0644"
    content: |
      [Unit]
      Description=Coder Agent
      After=network-online.target
      Wants=network-online.target

      [Service]
      User=eric
      ExecStart=/opt/coder/init
      Environment=CODER_AGENT_TOKEN=${coder_agent_token}
      Restart=always
      RestartSec=10
      TimeoutStopSec=90
      KillMode=process

      OOMScoreAdjust=-900
      SyslogIdentifier=coder-agent

      [Install]
      WantedBy=multi-user.target
runcmd:
  - chown eric:eric /home/eric
  - curl -fsSL https://tailscale.com/install.sh | sh
  - tailscale up --auth-key="${ts_auth}" --accept-routes --accept-dns
  - systemctl enable coder-agent
  - systemctl start coder-agent

