#cloud-config
users:
  - name: ${username}
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: sudo
    shell: /bin/bash
apt:
  sources:
    tailscale.list:
      source: deb https://pkgs.tailscale.com/stable/ubuntu focal main
      keyid: 2596A99EAAB33821893C0A79458CA832957F5868
packages: 
  - tailscale
  - git
mounts:
  - [
      "LABEL=${home_volume_label}",
      "/home/${username}",
      auto,
      "defaults,uid=1000,gid=1000",
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
      User=${username}
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
  - chown ${username}:${username} /home/${username}
  - tailscale up --auth-key=${tailscale_key} --accept-routes --accept-dns
  - systemctl enable coder-agent
  - systemctl start coder-agent

