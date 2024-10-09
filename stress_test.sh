#!/bin/bash

# Disk Stress
dd if=/dev/zero of=/tmp/testfile bs=1M count=100 iflag=fullblock
rm /tmp/testfile

# CPU Stress
stress --cpu 2 --timeout 60

# Memory Stress (adjust --vm-bytes to a safe value)
stress --vm 2 --vm-bytes 128M --timeout 60
