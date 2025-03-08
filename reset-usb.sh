#!/bin/bash

echo -n '0000:04:00.3' | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind
sleep 2
echo -n '0000:04:00.3' | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind

echo -n '0000:04:00.4' | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind
sleep 2
echo -n '0000:04:00.4' | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind

echo "USB ports reset successfully!"
