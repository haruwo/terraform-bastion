#!/usr/bin/env bash -ex -o pipefail
# for userdata

#----------------------------------------
# init
#----------------------------------------
sudo apt -y update
sudo apt -y install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades  # Choose "Yes"

#----------------------------------------
# amazon-ssm-agent setting
#----------------------------------------
sudo snap install amazon-ssm-agent --classic
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
