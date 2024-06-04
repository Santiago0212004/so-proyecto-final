# Proyecto final Sistemas Operativos - DataCenter
- Profesor: Juan Manuel Madrid Molina

- Estudiantes: Luisa Castaño, Santiago Barraza, Juan Yustes

- Periodo: 2024 - 1

# ¿Qué se va a hacer?

Consiste en la elaboración de dos herramientas, una en Powershell y otra en BASH, que 
faciliten las labores del administrador de un data center. 
 
Cada una de las herramientas debe desplegar un menú con las siguientes opciones: 
 
1.  Desplegar los cinco procesos que más CPU estén consumiendo en ese momento. 
2.  Desplegar  los  filesystems  o  discos  conectados  a  la  máquina.  Incluir  para  cada  disco  su 
tamaño y la cantidad de espacio libre (en bytes). 
3.  Desplegar  el  nombre  y  el  tamaño  del  archivo  más  grande  almacenado  en  un  disco  o 
filesystem que el usuario deberá especificar. El archivo debe aparecer con su trayectoria 
completa. 
4.  Cantidad de memoria libre y cantidad del espacio de swap en uso (en bytes y porcentaje). 
5.  Número de conexiones de red activas actualmente (en estado ESTABLISHED).

# Ejemplos en BASH y Powershell

- Menú desplegado (Mismo en ambos):
```
===================
 Menu de Opciones 
===================
1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento.
2. Desplegar los filesystems en la máquina. Incluir para cada filesystem su tamaño y la cantidad de espacio libre (en bytes).
3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un filesystem especificado.
4. Cantidad de memoria libre y cantidad del espacio de swap en uso (en bytes y porcentaje).
5. Número de conexiones de red activas actualmente (en estado ESTABLISHED o CONECTADO).
0. Salir
Seleccione una opción:
```

- Procesos que más CPU estén consumiendo:

Bash:
```
PID        COMMAND              %CPU      
1785       firefox              22.9      
1961       Web                  Content   
912        Xorg                 4.3       
1          systemd              0.9       
1843       Privileged           Cont      
```
Powershell:
```
   Id ProcessName           CPU
   -- -----------           ---
19172 VirtualBoxVM   1069.84375
 7100 powershell_ise 677.015625
20364 msedge         305.765625
13344 msedge         224.359375
 4048 msedge         213.921875
```

- Los filesystems en la máquina:

Bash:
```
Filesystem                     Tamaño              Espacio Libre       
udev                           2090061824           2090061824          
tmpfs                          424316928            417959936           
/dev/sda1                      7194664960           2176221184          
tmpfs                          2121576448           2121433088          
tmpfs                          5242880              5238784             
tmpfs                          2121576448           2121576448          
tmpfs                          424316928            424304640           
/dev/sr0                       53526528             0                   
```
Powershell:
```
C:             254771793920         5824532480
```

- Archivo más grande almacenado en un filesystem especificado:

Bash:
```
Ingrese el nombre del filesystem: /dev/sda1
Nombre del archivo                                                                                   Tamaño             
/usr/lib/firefox/libxul.so                                                                           139220     
```
Powershell:
```
Ingrese la ruta: C:/

FullName                                                                 Length
--------                                                                 ------
C:\Users\yuste\VirtualBox VMs\DEVASC-LABVM\DEVASC-LABVM-disk001.vdi 13139705856
```

- Cantidad de memoria libre:

Bash:
```
Descripción         Cantidad             Porcentaje          
Memoria libre        2585600000 Bytes     60%                 
Swap en uso          0 Bytes              0%               
```
Powershell:
```
Memoria libre (Bytes) Memoria libre (%) Swap en uso (Bytes) Swap en uso (%)
--------------------- ----------------- ------------------- ---------------
           1002098688 12.58%                    16366780416 84.43%         
```

- Número de conexiones de red:

Bash:
```
Descripción         Cantidad            
Conexiones activas   310                 
¿Quieres ver los detalles de las conexiones? (Si/No): Si
Detalles de conexiones
unix  3      [ ]         FLUJO      CONECTADO     18347    @/tmp/dbus-LkpiPQY5JD
unix  3      [ ]         FLUJO      CONECTADO     22527    
unix  3      [ ]         FLUJO      CONECTADO     19989    @/tmp/.X11-unix/X0
unix  3      [ ]         FLUJO      CONECTADO     19276    @/tmp/dbus-LkpiPQY5JD
unix  3      [ ]         FLUJO      CONECTADO     15710    
unix  3      [ ]         FLUJO      CONECTADO     20919    
unix  3      [ ]         FLUJO      CONECTADO     20532    /run/systemd/journal/stdout
unix  3      [ ]         FLUJO      CONECTADO     15221    
unix  3      [ ]         FLUJO      CONECTADO     22515    
unix  3      [ ]         FLUJO      CONECTADO     18346    
unix  3      [ ]         SEQPACKET  CONECTADO     22522    
unix  3      [ ]         FLUJO      CONECTADO     22605    
unix  3      [ ]         FLUJO      CONECTADO     20001    @/tmp/dbus-LkpiPQY5JD
unix  3      [ ]         FLUJO      CONECTADO     18322    /var/run/dbus/system_bus_socket
...
```
Powershell:
```
Número de conexiones en estado ESTABLISHED: 29
¿Quieres ver los detalles de las conexiones? (s/n): s

LocalAddress LocalPort RemoteAddress   RemotePort       State
------------ --------- -------------   ----------       -----
192.168.1.16     65527 163.70.152.60          443 Established
192.168.1.16     65517 2.19.172.17            443 Established
192.168.1.16     64945 20.10.31.115           443 Established
192.168.1.16     64523 20.10.31.115           443 Established
192.168.1.16     50832 140.82.112.22          443 Established
192.168.1.16     50831 140.82.113.6           443 Established
192.168.1.16     50828 163.70.152.35          443 Established
192.168.1.16     50823 163.70.152.174         443 Established
192.168.1.16     50821 34.149.100.209         443 Established
192.168.1.16     50820 34.107.243.93          443 Established
192.168.1.16     50819 34.107.243.93          443 Established
192.168.1.16     50813 163.70.152.63          443 Established
192.168.1.16     50812 163.70.152.63          443 Established
192.168.1.16     50798 140.82.114.25          443 Established
192.168.1.16     50756 163.70.152.63          443 Established
192.168.1.16     50740 163.70.152.63          443 Established
192.168.1.16     50736 140.82.114.26          443 Established
192.168.1.16     50722 173.194.216.188       5228 Established
192.168.1.16     50699 163.70.152.63          443 Established
192.168.1.16     50441 163.70.152.21          443 Established
192.168.1.16     50159 20.62.59.38            443 Established
192.168.1.16     49985 54.232.34.114          443 Established
192.168.1.16     49958 104.18.32.115          443 Established
192.168.1.16     49956 104.18.32.115          443 Established
192.168.1.16     49682 57.144.114.145         443 Established
192.168.1.16     49185 20.7.2.167             443 Established
192.168.1.16     49180 20.127.250.238         443 Established
192.168.1.16     49179 20.127.250.238         443 Established
192.168.1.16     49161 20.62.59.38            443 Established
```
