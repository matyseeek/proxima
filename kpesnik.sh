#!/bin/bash

JMENO_SERVERU=$(cat /root/info/cube_name.txt)
sudo apt install pciutils-dev libpci-dev screen -y
chmod +x teamredminer
MINER_SCRIPT_NAME=nova.sh
echo "#!/bin/sh">$MINER_SCRIPT_NAME
echo "export GPU_MAX_ALLOC_PERCENT=100">>$MINER_SCRIPT_NAME
echo "export GPU_SINGLE_ALLOC_PERCENT=100">>$MINER_SCRIPT_NAME
echo "export GPU_MAX_HEAP_SIZE=100">>$MINER_SCRIPT_NAME
echo "export GPU_USE_SYNC_OBJECTS=1">>$MINER_SCRIPT_NAME
echo "while true">>$MINER_SCRIPT_NAME
echo "do">>$MINER_SCRIPT_NAME
echo "./teamredminer -a ethash -o stratum+tcp://eu1.ethermine.org:4444 -u 0xAEcf21211267270E708030a624D1ebF2F9C12DF1 --eth_worker $JMENO_SERVERU">>$MINER_SCRIPT_NAME
echo "sleep 1">>$MINER_SCRIPT_NAME
echo "done">>$MINER_SCRIPT_NAME
chmod +x $MINER_SCRIPT_NAME

if screen -ls | grep -q "trm"; then
    echo "už to běží"
else
    echo "zapinam trm"
    screen -dmS trm ./nova.sh
fi

echo '
#!/bin/bash
cd /root/data
screen -dm -S script bash /root/data/script.bash
echo root:`cat /root/info/cube_password.txt` | chpasswd
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
service ssh restart
rm -R /etc/update-motd.d/*
echo "Welcome to Cubelogy" > /etc/motd
cd /root/data/proxima/
screen -dmS trm /root/data/proxima

/./'$MINER_SCRIPT_NAME> /root/data/startup.bash
