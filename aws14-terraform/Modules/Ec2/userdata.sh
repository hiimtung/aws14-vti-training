#cloud-config
repo_update: true
repo_upgrade: all

packages:
  - httpd
  - curl

runcmd:
  - [ sh, -c, "amazon-linux-extras install -y epel" ]
  - [ sh, -c, "yum -y install stress-ng" ]
  - [ sh, -c, "echo hello world. My instance-id is $(curl -s http://169.254.169.254/latest/meta-data/instance-id). My instance-type is $(curl -s http://169.254.169.254/latest/meta-data/instance-type). > /var/www/html/index.html" ]
  - [ sh, -c, "systemctl enable httpd" ]
  - [ sh, -c, "systemctl start httpd" ]
