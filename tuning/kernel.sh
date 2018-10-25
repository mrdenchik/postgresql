#!/bin/bash

#источники
#https://www.percona.com/blog/2018/08/29/tune-linux-kernel-parameters-for-postgresql-optimization/
#https://postgrespro.ru/docs/postgrespro/10/kernel-resources

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
#затем
echo "vm.nr_hugepages=VALUE" >> /etc/sysctl.conf
#в postgresql.conf включаем huge_pages=on
#сведем к минимуму использование свопа
echo "vm.swappiness=1" >> /etc/sysctl.conf
#
echo "vm.overcommit_memory=2"
#значение по умолчанию
#echo "vm.overcommit_ratio=50" >> /etc/sysctl.conf
#процент памяти, заполненной грязными страницами, когда нужно их сбросить на диск
echo "vm.dirty_background_ratio=5" >> /etc/sysctl.conf
#
echo "vm.dirty_background_bytes=25" >> /etc/sysctl.conf

#после изменения параметров ядра
sysctl -p
