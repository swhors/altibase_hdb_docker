#!/usr/bin/env bash
patch_sysctl_conf(){
    TARGET="/etc/sysctl.conf"
    echo "# Controls the default maxmimum size of a mesage queue" >> $TARGET
    echo "kernel.msgmnb = 65536" >> $TARGET
    echo "# Controls the maximum size of a message, in bytes" >> $TARGET
    echo "kernel.msgmax = 65536" >> $TARGET
    echo "# Controls the maximum shared segment size, in bytes" >> $TARGET
    echo "kernel.shmmax = 68719476736000" >> $TARGET
    echo "# Controls the maximum number of shared memory segments, in pages" >> $TARGET
    echo "kernel.shmall = 4294967296" >> $TARGET
    echo "fs.suid_dumpable = 1" >> $TARGET
    echo "fs.aio-max-nr = 1048576" >> $TARGET
    echo "fs.file-max = 6815744" >> $TARGET
    echo "# semaphores: semmsl, semmns, semopm, semmni" >> $TARGET
    echo "kernel.sem = 1024 32000 1024 1024" >> $TARGET
    echo "net.ipv4.ip_local_port_range = 32768 61000" >> $TARGET
    echo "net.core.rmem_default = 4194304" >> $TARGET
    echo "net.core.rmem_max = 4194304" >> $TARGET
    echo "net.core.wmem_default = 262144" >> $TARGET
    echo "net.core.wmem_max = 1048586" >> $TARGET
    echo "# core filename pattern (core.execution_file_name.time)" >> $TARGET
    echo "kernel.core_uses_pid = 0" >> $TARGET
    echo "kernel.core_pattern = core.%e.%t" >> $TARGET
}

patch_kernel_mem()
{
    echo "Original ===="
    cat /proc/sys/kernel/shmmax
    cat /proc/sys/kernel/sem
    echo 16147483648 > /proc/sys/kernel/shmmax
    echo 1024 32000 1024 1024 > /proc/sys/kernel/sem
    echo "Modifiex ===="
    cat /proc/sys/kernel/shmmax
    cat /proc/sys/kernel/sem
}


patch_sysctl_conf
#patch_kernel_mem
