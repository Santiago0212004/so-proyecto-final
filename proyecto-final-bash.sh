#!/bin/bash
# Script en BASH para facilitar las labores del administrador de un data center

function show_menu() {
    clear
    echo "==================="
    echo " Menu de Opciones "
    echo "==================="
    echo "1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento."
    echo "2. Desplegar los filesystems en la máquina. Incluir para cada filesystem su tamaño y la cantidad de espacio libre (en bytes)."
    echo "3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un filesystem especificado."
    echo "4. Cantidad de memoria libre y cantidad del espacio de swap en uso (en bytes y porcentaje)."
    echo "5. Número de conexiones de red activas actualmente (en estado ESTABLISHED o CONECTADO)."
    echo "0. Salir"
}

function show_top_processes() {
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk '{printf "%-10s %-20s %-10s\n", $1, $2, $3}'
}

function show_filesystems() {
    printf "%-30s %-20s %-20s\n" "Filesystem" "Tamaño" "Espacio Libre"
    df -B1 --output=source,size,avail | awk 'NR==1 {next} {printf "%-30s %-20s %-20s\n", $1, $2, $3}'
}

function show_largest_file() {
    read -p "Ingrese el nombre del filesystem: " path
    mount_point=$(df -h | grep "$path" | awk '{print $6}')
    printf "%-100s %-20s\n" "Nombre del archivo" "Tamaño"
    find "$mount_point" -xdev -type f -exec ls -s {} + 2>/dev/null | sort -n -r | head -n 1 | awk '{printf "%-100s %-20s\n", $2, $1}'
}

function show_memory_and_swap() {
    free_output=$(free -b)

    mem_total=$(echo "$free_output" | grep Mem | awk '{print $2}')
    mem_free=$(echo "$free_output" | grep Mem | awk '{print $4}')
    mem_free_pct=$(( 100 * mem_free / mem_total ))

    swap_total=$(echo "$free_output" | grep Swap | awk '{print $2}')
    swap_used=$(echo "$free_output" | grep Swap | awk '{print $3}')
    swap_used_pct=$(( 100 * swap_used / swap_total ))

    printf "%-20s %-20s %-20s\n" "Descripción" "Cantidad" "Porcentaje"
    printf "%-20s %-20s %-20s\n" "Memoria libre" "$mem_free Bytes" "$mem_free_pct%"
    printf "%-20s %-20s %-20s\n" "Swap en uso" "$swap_used Bytes" "$swap_used_pct%"
}

function show_network_connections() {
    netstat_output=$(netstat -an)
    connection_count=$(echo "$netstat_output" | grep -c "CONECTADO")
    printf "%-20s %-20s\n" "Descripción" "Cantidad"
    printf "%-20s %-20s\n" "Conexiones activas" "$connection_count"

    echo -n "¿Quieres ver los detalles de las conexiones? (Si/No): "
    read details

    if [ "$details" == "Si" ]; then
        printf "%-20s\n" "Detalles de conexiones"
        echo "$netstat_output" | grep "CONECTADO" | awk '{printf "%-20s\n", $0}'
    fi
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
