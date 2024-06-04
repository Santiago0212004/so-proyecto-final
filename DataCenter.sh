#!/bin/bash
# Script en BASH para facilitar las labores del administrador de un data center

# Función para mostrar el menú de opciones
function show_menu() {
    clear  # Limpia la pantalla
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

# Función para mostrar los cinco procesos que más CPU están consumiendo
function show_top_processes() {
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk '{printf "%-10s %-20s %-10s\n", $1, $2, $3}'
    # ps -eo pid,comm,%cpu --sort=-%cpu: Obtiene una lista de procesos con su PID, nombre y porcentaje de CPU utilizado, ordenados por el uso de CPU en orden descendente.
    # head -n 6: Muestra solo las primeras seis líneas del resultado (incluyendo la cabecera).
    # awk '{printf "%-10s %-20s %-10s\n", $1, $2, $3}': Da formato a la salida para que sea más legible.
}

# Función para mostrar los filesystems y su información de tamaño y espacio libre
function show_filesystems() {
    printf "%-30s %-20s %-20s\n" "Filesystem" "Tamaño" "Espacio Libre"
    df -B1 --output=source,size,avail | awk 'NR==1 {next} {printf "%-30s %-20s %-20s\n", $1, $2, $3}'
    # df -B1 --output=source,size,avail: Muestra la lista de filesystems con su tamaño total y espacio disponible en bytes.
    # awk 'NR==1 {next} {printf "%-30s %-20s %-20s\n", $1, $2, $3}': Da formato a la salida, omitiendo la primera línea que contiene los nombres de las columnas.
}

# Función para mostrar el archivo más grande en un filesystem especificado
function show_largest_file() {
    read -p "Ingrese el nombre del filesystem: " path
    mount_point=$(df -h | grep "$path" | awk '{print $6}')
    # df -h | grep "$path" | awk '{print $6}': Encuentra el punto de montaje del filesystem especificado.
    
    printf "%-100s %-20s\n" "Nombre del archivo" "Tamaño"
    find "$mount_point" -xdev -type f -exec ls -s {} + 2>/dev/null | sort -n -r | head -n 1 | awk '{printf "%-100s %-20s\n", $2, $1}'
    # find "$mount_point" -xdev -type f -exec ls -s {} + 2>/dev/null: Busca archivos en el punto de montaje especificado y lista su tamaño en bloques.
    # sort -n -r: Ordena los archivos por tamaño en orden descendente.
    # head -n 1: Muestra solo el archivo más grande.
    # awk '{printf "%-100s %-20s\n", $2, $1}': Da formato a la salida para mostrar el nombre completo del archivo y su tamaño.
}

# Función para mostrar la memoria libre y el espacio de swap en uso
function show_memory_and_swap() {
    free_output=$(free -b)
    # free -b: Muestra el uso de memoria y swap en bytes.
    
    mem_total=$(echo "$free_output" | grep Mem | awk '{print $2}')
    mem_free=$(echo "$free_output" | grep Mem | awk '{print $4}')
    mem_free_pct=$(( 100 * mem_free / mem_total ))
    # Calcula la memoria libre y su porcentaje.
    
    swap_total=$(echo "$free_output" | grep Swap | awk '{print $2}')
    swap_used=$(echo "$free_output" | grep Swap | awk '{print $3}')
    swap_used_pct=$(( 100 * swap_used / swap_total ))
    # Calcula el espacio de swap en uso y su porcentaje.
    
    printf "%-20s %-20s %-20s\n" "Descripción" "Cantidad" "Porcentaje"
    printf "%-20s %-20s %-20s\n" "Memoria libre" "$mem_free Bytes" "$mem_free_pct%"
    printf "%-20s %-20s %-20s\n" "Swap en uso" "$swap_used Bytes" "$swap_used_pct%"
}

# Función para mostrar el número de conexiones de red activas
function show_network_connections() {
    netstat_output=$(netstat -an)
    # netstat -an: Muestra todas las conexiones de red y sus estados.
    
    connection_count=$(echo "$netstat_output" | grep -c "CONECTADO")
    # Cuenta el número de conexiones en estado "CONECTADO".
    
    printf "%-20s %-20s\n" "Descripción" "Cantidad"
    printf "%-20s %-20s\n" "Conexiones activas" "$connection_count"

    echo -n "¿Quieres ver los detalles de las conexiones? (Si/No): "
    read details

    if [ "$details" == "Si" ]; then
        printf "%-20s\n" "Detalles de conexiones"
        echo "$netstat_output" | grep "CONECTADO" | awk '{printf "%-20s\n", $0}'
        # Si el usuario quiere ver detalles, muestra todas las conexiones en estado "CONECTADO".
    fi
}

# Bucle principal que muestra el menú y maneja la selección del usuario
while true; do
    show_menu
    read -p "Seleccione una opción: " option
    case $option in
        1) show_top_processes ;;  # Muestra los procesos que más CPU consumen
        2) show_filesystems ;;    # Muestra los filesystems y su espacio disponible
        3) show_largest_file ;;   # Muestra el archivo más grande en un filesystem especificado
        4) show_memory_and_swap ;; # Muestra la memoria libre y el uso de swap
        5) show_network_connections ;; # Muestra el número de conexiones de red activas
        0) echo "Saliendo..."; exit ;; # Salir del script
        *) echo "Opción no válida. Por favor, seleccione una opción del 0 al 5." ;; # Maneja opciones inválidas
    esac
    read -p "Presione Enter para continuar..." # Pausa antes de volver al menú
done
