#!/bin/bash
export LIBVIRT_DEFAULT_URI=qemu:///system

RETI="lan-utenti lan-server lan-security default"
FIREWALL="opnsense"
ALTRE_VM="kali wazuh"

for vm in $ALTRE_VM $FIREWALL; do
  echo "Spengo la VM $vm..."
  virsh shutdown "$vm"
done

for vm in $ALTRE_VM $FIREWALL; do
  echo "Aspetto che $vm si spenga..."
  secondi=0
  while virsh list --name --state-running | grep -qx "$vm"; do
    sleep 2
    secondi=$((secondi + 2))
    if [ $secondi -ge 120 ]; then
      echo "$vm non si spegne da 2 minuti, spegnimento forzato."
      virsh destroy "$vm"
      break
    fi
  done
done

for rete in $RETI; do
  echo "Spengo la rete $rete..."
  virsh net-destroy "$rete"
done

virsh list --all
virsh net-list --all
