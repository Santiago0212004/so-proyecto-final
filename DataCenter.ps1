<#
.SYNOPSIS
Este Script permite facilitar operaciones en un data center.
.DESCRIPTION
Este script proporciona un menú interactivo que permite desplegar información sobre los procesos, sistemas de archivos, memoria, swap y conexiones de red.
.EXAMPLE
.\DataCenter.ps1
#>

# Función para mostrar el menú de opciones
function Menu {
    Write-Host "--------------------"
    Write-Host "| Menu de Opciones |"
    Write-Host "--------------------"
    Write-Host "1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento."
    Write-Host "2. Desplegar los filesystems o discos conectados a la máquina. Incluir para cada disco su tamaño y la cantidad de espacio libre (en bytes)."
    Write-Host "3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem especificado."
    Write-Host "4. Cantidad de memoria libre y cantidad del espacio de swap en uso (en bytes y porcentaje)."
    Write-Host "5. Número de conexiones de red activas actualmente (en estado ESTABLISHED)."
    Write-Host "0. Salir"
}

<#
.SYNOPSIS
1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento.
#>
function Show-TopCpuProcesses {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table -Property Id, ProcessName, CPU
    # Get-Process: Obtiene una lista de los procesos actuales.
    # Sort-Object CPU -Descending: Ordena los procesos por el uso de CPU en orden descendente.
    # Select-Object -First 5: Selecciona los primeros cinco procesos.
    # Format-Table -Property Id, ProcessName, CPU: Da formato a la salida mostrando el ID del proceso, el nombre del proceso y el uso de CPU.
}

<#
.SYNOPSIS
2. Desplegar los filesystems o discos conectados a la máquina. Incluir para cada disco su tamaño y la cantidad de espacio libre (en bytes).
#>
function Show-Filesystems {
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, @{n='Total Size (Bytes)'; e={$_.Size}}, @{n='Free Space (Bytes)'; e={$_.FreeSpace}}
    # Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3": Obtiene información sobre los discos duros locales.
    # Select-Object DeviceID, @{n='Total Size (Bytes)'; e={$_.Size}}, @{n='Free Space (Bytes)'; e={$_.FreeSpace}}: Selecciona el ID del dispositivo, el tamaño total y el espacio libre en bytes.
}

<#
.SYNOPSIS
3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem especificado.
.PARAMETER Path
Ruta del disco o filesystem a inspeccionar.
#>
function Show-LargestFile {
    param (
        [Parameter(Mandatory=$True)]
        [string]$Path
    )
    
    if (Test-Path $Path) { # Verifica si la ruta especificada existe
        try {
            $largestFile = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer } | Sort-Object Length -Descending | Select-Object -First 1
            # Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue: Obtiene todos los elementos dentro del path especificado, recursivamente.
            # Where-Object { -not $_.PSIsContainer }: Filtra solo los archivos (no directorios).
            # Sort-Object Length -Descending: Ordena los archivos por tamaño en orden descendente.
            # Select-Object -First 1: Selecciona el archivo más grande.
            
            if ($largestFile) {
                $largestFile | Format-Table -Property FullName, Length
                # Format-Table -Property FullName, Length: Da formato a la salida mostrando el nombre completo del archivo y su tamaño.
            } else {
                Write-Host "No se encontraron archivos en la ruta especificada."
            }
        } catch {
            Write-Host "Error al acceder a la ruta especificada: $_"
        }
    } else {
        Write-Host "La ruta especificada no existe."
    }
}

<#
.SYNOPSIS
4. Cantidad de memoria libre y la cantidad de espacio de swap en uso (en bytes y porcentaje).
#>
function Show-MemoryAndSwap {
    $memInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    # Get-CimInstance -ClassName Win32_OperatingSystem: Obtiene información del sistema operativo.
    
    $freeMemoryBytes = $memInfo.FreePhysicalMemory * 1KB
    $totalMemoryBytes = $memInfo.TotalVisibleMemorySize * 1KB
    $freeMemoryPct = [math]::round(($freeMemoryBytes / $totalMemoryBytes) * 100, 2)
    # Calcula la memoria libre en bytes y como porcentaje.
    
    $swapTotalBytes = $memInfo.TotalVirtualMemorySize * 1KB
    $swapInUseBytes = ($memInfo.TotalVirtualMemorySize - $memInfo.FreeVirtualMemory) * 1KB
    $swapInUsePct = [math]::round(($swapInUseBytes / $swapTotalBytes) * 100, 2)
    # Calcula el espacio de swap en uso en bytes y como porcentaje.
    
    $output = [PSCustomObject]@{
        "Memoria libre (Bytes)" = $freeMemoryBytes
        "Memoria libre (%)" = "$freeMemoryPct`%"
        "Swap en uso (Bytes)" = $swapInUseBytes
        "Swap en uso (%)" = "$swapInUsePct`%"
    }
    $output | Format-Table
    # Da formato a la salida mostrando la memoria libre y el uso de swap en bytes y porcentaje.
}

<#
.SYNOPSIS
5. Número de conexiones de red activas actualmente (en estado ESTABLISHED), también sus detalles si el usuario lo solicita.
#>
function Show-NetworkConnections {
    $connections = Get-NetTCPConnection -State Established
    # Get-NetTCPConnection -State Established: Obtiene todas las conexiones de red en estado ESTABLISHED.
    
    $count = $connections.Count
    Write-Host "Número de conexiones en estado ESTABLISHED: $count"
    
    $response = Read-Host "¿Quieres ver los detalles de las conexiones? (s/n)"
    if ($response -eq 's') {
        $connections | Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Format-Table -AutoSize
        # Si el usuario quiere ver los detalles, muestra la dirección local, puerto local, dirección remota, puerto remoto y estado de cada conexión.
    }
}

# Bucle principal que muestra el menú y maneja la selección del usuario
while ($true) {
    Menu
    $choice = Read-Host "Seleccione una opción"
    switch ($choice) {
        1 { Show-TopCpuProcesses } # Muestra los procesos que más CPU consumen
        2 { Show-Filesystems } # Muestra los filesystems y su espacio disponible
        3 { 
            $path = Read-Host "Ingrese la ruta"
            Show-LargestFile -path $path # Muestra el archivo más grande en un filesystem especificado
        }
        4 { Show-MemoryAndSwap } # Muestra la memoria libre y el uso de swap
        5 { Show-NetworkConnections } # Muestra el número de conexiones de red activas
        0 {
            Write-Host "Saliendo..."
            exit # Salir del script
        }
        default { Write-Host "Opción no válida, ingrese un valor correcto" } # Maneja opciones inválidas
    }
}
