#!/bin/bash
export LIBVIRT_DEFAULT_URI=qemu:///system

RETI="default lan-utenti lan-server lan-security"
FIREWALL="opnsense"
ALTRE_VM="kali"

for rete in $RETI; do
  echo "Accendo la rete $rete..."
  virsh net-start "$rete"
done

echo "Accendo il firewall $FIREWALL..."
virsh start "$FIREWALL"

echo "Aspetto 30 secondi che il firewall sia pronto..."
sleep 30

for vm in $ALTRE_VM; do
  echo "Accendo la VM $vm..."
  virsh start "$vm"
done

virsh net-list --all
virsh list --all
