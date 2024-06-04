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

# Ejemplos

- Menú desplegado:
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
```
PID        COMMAND              %CPU      
1785       firefox              22.9      
1961       Web                  Content   
912        Xorg                 4.3       
1          systemd              0.9       
1843       Privileged           Cont      
```

- Los filesystems en la máquina:
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

- Archivo más grande almacenado en un filesystem especificado:
```
Ingrese el nombre del filesystem: yus
Nombre del archivo                                                                                   Tamaño             
/media/yus/VBox_GAs_7.0.14/VBoxWindowsAdditions-amd64.exe                                            15395       
```

- Cantidad de memoria libre:
```
Descripción         Cantidad             Porcentaje          
Memoria libre        2585600000 Bytes     60%                 
Swap en uso          0 Bytes              0%                  
```

- Número de conexiones de red:
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
```
