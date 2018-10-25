#!/bin/bash
pid=$(head -1 $PGDATA/postmaster.pid)
echo "PID: $pid"
peak=$(grep ^VmPeak /proc/$pid/status | awk '{print $2}')
echo "VmPeak: $peak"
hps=$(grep ^Hugepagesize /proc/meminfo | awk '{print $2}')
echo "Hugepagesize: $hps"
hp=$((peak/hps))
echo "Set Huge Page = $hp"
