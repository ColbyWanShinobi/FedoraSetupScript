#!/usr/bin/env bash

set -e -x

sudo dnf install -y @virtualization
sudo dnf install -y virt-manager virtiofsd

sudo systemctl enable --now libvirtd

sudo virsh net-start default || true
sudo virsh net-autostart default || true

sudo usermod -aG kvm,input,libvirt ${USER}
newgrp kvm || true
newgrp input || true
newgrp libvirt || true
