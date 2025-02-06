#!/bin/bash

MEMORY_USAGE=$(free | awk '/^Mem/ { printf("%.0f", $3/$2 * 100) }')
NETWORK_USAGE=$(cat /proc/net/dev | awk '/eth0/ {print $2}')

echo "Uso de memória: $MEMORY_USAGE%"
echo "Uso de rede: $NETWORK_USAGE bytes recebidos"

if [ "MEMORY_USAGE" -ge 80 ]; then
    echo "Escalando recursos..."
    /bin/bash /Users/yurimiguel/Desktop/AutoScaleOps/monitor/scale_up.sh
    exit 1
elif [ "MEMORY_USAGE" -le 50 ]; then
    echo "Reduzindo recursos..."
    /bin/bash /Users/yurimiguel/Desktop/AutoScaleOps/monitor/scale_down.sh
    exit 1
else
    echo "Monitoramento completo, nenhuma ação necessária."
    exit 0
fi