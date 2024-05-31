#!/bin/bash
# Script en BASH para facilitar las labores del administrador de un data center

function show_menu() {
    clear
    echo "==================="
    echo " Menu de Opciones "
    echo "==================="
    echo "1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento."
    echo "2. Desplegar los filesystems o discos conectados a la máquina. Incluir para cada disco su tamaño y la cantidad de espacio libre (en bytes)."
    echo "3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem especificado."
    echo "4. Cantidad de memoria libre y cantidad del espacio de swap en uso (en bytes y porcentaje)."
    echo "5. Número de conexiones de red activas actualmente (en estado ESTABLISHED)."
    echo "0. Salir"
}

function show_top_processes() {
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

function show_filesystems() {
    df -h --output=source,size,avail
}

function show_largest_file() {
    read -p "Ingrese la ruta del disco o filesystem: " path
    mount_point=$(df -h | grep "$path" | awk '{print $NF}')
    echo "$mount_point"
    find "$mount_point" -xdev -type f -exec ls -s {} + 2>/dev/null | sort -n -r | head -n 1
}

function show_memory_and_swap() {
    free -b
    swap_total=$(free -b | grep Swap | awk '{print $2}')
    swap_used=$(free -b | grep Swap | awk '{print $3}')
    swap_used_pct=$(( 100 * swap_used / swap_total ))
    echo "Swap en uso: $swap_used Bytes ($swap_used_pct%)"
}

function show_network_connections() {
    netstat -an | grep "CONECTADO" | wc -l
}

while true; do
    show_menu
    read -p "Seleccione una opción: " option
    case $option in
        1) show_top_processes ;;
        2) show_filesystems ;;
        3) show_largest_file ;;
        4) show_memory_and_swap ;;
        5) show_network_connections ;;
        0) echo "Saliendo..."; exit ;;
        *) echo "Opción no válida. Por favor, seleccione una opción del 0 al 5." ;;
    esac
    read -p "Presione Enter para continuar..."
done
