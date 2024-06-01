<#
.SYNOPSIS
Este Scrip permite facilitar operaciones en un data center.
.DESCRIPTION
Este script proporciona un menú interactivo que permite facilitar operaciones y permite desplegar información sobre los procesos, sistemas de archivos, memoria, swap y conexiones de red.
.EXAMPLE
.\DataCenter.ps1
#>

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
Desplegar los cinco procesos que más CPU estén consumiendo en ese momento.
#>
function Show-TopCpuProcesses {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table -Property Id, ProcessName, CPU
}

<#
.SYNOPSIS
Desplegar los filesystems o discos conectados a la máquina. Incluir para cada disco su tamaño y la cantidad de espacio libre (en bytes).
#>
function Show-Filesystems {
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, @{n='Total Size (Bytes)'; e={$_.Size}}, @{n='Free Space (Bytes)'; e={$_.FreeSpace}}
}

<#
.SYNOPSIS
Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem especificado.
.PARAMETER Path
Ruta del disco o filesystem a inspeccionar.
#>
function Show-LargestFile {
    param (
        [Parameter(Mandatory=$True)]
        [string]$Path
    )
    if (Test-Path $Path) {
        Get-ChildItem -Path $Path -Recurse | Sort-Object Length -Descending | Select-Object FullName, Length -First 1 | Format-Table -Property FullName, Length
    } else {
        Write-Host "La ruta especificada no existe."
    }
}

<#
.SYNOPSIS
Mostrar la cantidad de memoria libre y la cantidad de espacio de swap en uso (en bytes y porcentaje).
#>
function Show-MemoryAndSwap {
    $memInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $freeMemoryBytes = $memInfo.FreePhysicalMemory * 1KB
    $swapTotalBytes = $memInfo.TotalVirtualMemorySize * 1KB
    $swapInUseBytes = ($memInfo.TotalVirtualMemorySize - $memInfo.FreeVirtualMemory) * 1KB
    $swapInUsePct = [math]::round(($swapInUseBytes / $swapTotalBytes) * 100, 2)
    
    $output = [PSCustomObject]@{
        "Memoria libre (Bytes)" = $freeMemoryBytes
        "Swap en uso (Bytes)" = $swapInUseBytes
        "Swap en uso (%)" = "$swapInUsePct`%"
    }
    $output | Format-Table -AutoSize
}


<#
.SYNOPSIS
Mostrar el número de conexiones de red activas actualmente (en estado ESTABLISHED), también sus detalles si el usuario lo solicita.
#>
function Show-NetworkConnections {
    $connections = Get-NetTCPConnection -State Established
    $count = $connections.Count
    Write-Host "Número de conexiones en estado ESTABLISHED: $count"
    $response = Read-Host "¿Quieres ver los detalles de las conexiones? (s/n)"
    if ($response -eq 's') {
        $connections | Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Format-Table -AutoSize
    }
}


while ($true) {
    Menu
    $choice = Read-Host "Seleccione una opción"
    switch ($choice) {
        1 { Show-TopCpuProcesses }
        2 { Show-Filesystems }
        3 { 
            $path = Read-Host "Ingrese la ruta"
            Show-LargestFile -path $path
        }
        4 { Show-MemoryAndSwap }
        5 { Show-NetworkConnections }
        0 {
            Write-Host "Saliendo..."
            exit
        }
        default { Write-Host "Opción no válida, ingrese un valor correcto" }
    }
}
