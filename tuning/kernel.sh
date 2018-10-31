#!/bin/bash

#источники
#https://www.percona.com/blog/2018/08/29/tune-linux-kernel-parameters-for-postgresql-optimization/
#https://postgrespro.ru/docs/postgrespro/10/kernel-resources

#настройки выставляются на master и slave!

#SHMMAX/SHMALL
#текущие настройки
ipcs -lm
#размер страницы
getconf PAGE_SIZE
#изменить параметры ядра
echo "kernel.shmmax=VALUE" >> /etc/sysctl.conf
echo "kernel.shmall=VALUE" >> /etc/sysctl.conf

#HUGE PAGE
#текущие настройки
cat /proc/meminfo | grep -i huge
#для получения нового значения параметра vm.nr_hugepages нужно запустить скрипт
#GetNuberOfRequiredHugePages.sh под root
#так же можно рассчитать как sharred_buffers(in kb)/PAGE_SIZE
echo "vm.nr_hugepages=VALUE" >> /etc/sysctl.conf
#в postgresql.conf включаем huge_pages=on
#сведем к минимуму использование свопа
echo "vm.swappiness=1" >> /etc/sysctl.conf
#режим строго выделения памяти
echo "vm.overcommit_memory=2"
#значение по умолчанию
#echo "vm.overcommit_ratio=50" >> /etc/sysctl.conf
#
#в % или в байтах память заполненная грязными страницами, когда нужно их сбросить на диск
#для SSD-диска можно оставить по дефолту(?)
#выставляем или проценты или байты
#для background делаем 64MB
echo "vm.dirty_background_bytes=67108864" >> /etc/sysctl.conf
#для foreground установавливаем равное размеру кэша диска, для RAID с 512MB кэша:
echo "vm.dirty_bytes=536870912" >> /etc/sysctl.conf

#SCHEDULER
#значение по умолчанию(500000), можно выставить большое
#sysctl kernel.sched_migration_cost_ns
echo "kernel.sched_autogroup_enabled=0" >> /etc/sysctl.conf

#NUMA
#отключить NUMA в BIOS или при загрузке ядра или
#echo "vm.zone_reclaim_mode=0" >> /etc/sysctl.conf
#numactl --interleave = all /etc/init.d/postgresql start
#echo "kernel.numa_balancing=0" >> /etc/sysctl.conf

#POWER SAVING POLICY
#посмотреть режим питания
#cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
#для каждого процессора выпоняем ??? не работает после перезагрузки
#echo performance >> /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

#vm.min_free_kbytes
#отключить использование barrier для жестких дисков с бэкапом по питанию


#после изменения параметров ядра
sysctl -p
