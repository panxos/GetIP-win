De acuerdo, te doy una explicación del script para un README de github. Puedes usar el siguiente texto:

# Script de PowerShell para obtener información de las interfaces de red

Este script de PowerShell te permite obtener una tabla ordenada con la información de las interfaces de red que están activas en tu sistema operativo Windows. La tabla muestra el alias de la interfaz, la dirección IP, la máscara de red, el gateway y los servidores DNS activados en cada interfaz.

## Requisitos

Para ejecutar este script necesitas tener instalado PowerShell en tu sistema operativo Windows. Puedes verificar si tienes PowerShell instalado abriendo una ventana de comando y escribiendo `powershell -version`. Si no tienes PowerShell instalado, puedes seguir las instrucciones de este enlace: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell

## Uso

Para usar este script, sigue estos pasos:

- Descarga el archivo `getip.ps1` desde este repositorio o copia el código fuente desde aquí:

```powershell
# Obtener las interfaces de red activas
$interfaces = Get-NetIPInterface -ConnectionState Connected

# Crear una tabla vacía
$table = @()

# Recorrer cada interfaz
foreach ($interface in $interfaces) {

    # Obtener la dirección IP, la máscara de red y el gateway
    $ipaddress = Get-NetIPAddress -InterfaceIndex $interface.InterfaceIndex -AddressFamily IPv4
    $gateway = (Get-NetRoute -InterfaceIndex $interface.InterfaceIndex -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty NextHop)

    # Obtener los servidores DNS
    $dns = Get-DnsClientServerAddress -InterfaceIndex $interface.InterfaceIndex -AddressFamily IPv4

    # Crear un objeto con los datos de la interfaz
    $object = [PSCustomObject]@{
        "Interfaz de red" = $interface.InterfaceAlias
        "Dirección IP" = $ipaddress.IPAddress
        "Prefijo" = $ipaddress.PrefixLength
        "Gateway" = $gateway
        "Servidores DNS" = $dns.ServerAddresses -join ", "
    }

    # Agregar el objeto a la tabla
    $table += $object
}

# Imprimir la tabla ordenada por alias de interfaz
$table | Sort-Object "Interfaz de red" | Format-Table -AutoSize
```

- Abre una ventana de comando y navega hasta la ruta donde guardaste el archivo `script.ps1`.
- Ejecuta el siguiente comando:

```cmd
powershell -File "getips.ps1"
```

- Verás una salida similar a esta:

```
Interfaz de red               Dirección IP   Prefijo Gateway      Servidores DNS
---------------               ------------   ------- -------      --------------
Ethernet 2                    10.200.235.70       24 10.200.235.1 94.140.14.49, 94.140.14.59, 1.1.1.1
Loopback Pseudo-Interface 1   127.0.0.1            8
Loopback Pseudo-Interface 1   127.0.0.1            8
Npcap Loopback Adapter        169.254.228.70      16
VMware Network Adapter VMnet3 192.168.153.1       24
VMware Network Adapter VMnet4 172.22.154.1        24
```

## Parámetros

El script no acepta ningún parámetro, pero puedes modificar el código fuente para cambiar algunos aspectos del funcionamiento del script, como por ejemplo:

- El estado de conexión de las interfaces que quieres obtener (`Connected`, `Disconnected` o `All`).
- La familia de direcciones IP que quieres obtener (`IPv4` o `IPv6`).
- El criterio de ordenación de la tabla (`InterfaceAlias`, `IPAddress`, `DefaultGateway` o `DNSServer`).

## Usarlo como un comando del sistema.

Para que puedas usar el script desde cualquier ruta del sistema operativo, tienes algunas opciones:

Puedes guardar el script en un archivo con extensión .ps1 y ejecutarlo desde la línea de comandos usando el parámetro -File de powershell y la ruta completa del archivo1. Por ejemplo:
```
powershell -File "C:\Program Files\Folder\getips.ps11" -Verbose -Restart
```
Puedes agregar la ruta del script a la variable de entorno PATH, que es una lista de directorios donde Windows busca los programas ejecutables. Así podrías ejecutar el script sin tener que escribir la ruta completa cada vez. Para hacer esto
Puedes crear un alias para el script, que es un nombre corto que puedes usar en lugar de la ruta completa. Para hacer esto, puedes usar el cmdlet New-Alias de powershell y especificar el nombre del alias y la ruta del script. Por ejemplo:
```
New-Alias -Name getips -Value "C:\Program Files\Folder\getips.ps1"
```
Luego podrías ejecutar el script usando el alias:
```
getips -Verbose -Restart
```

O simplemente ejecutar

```
getip
```
El resultado seria  algo similar a esto:

```
InterfaceAlias                IPAddress      PrefixLength DefaultGateway DNSServer
--------------                ---------      ------------ -------------- ---------
Ethernet 2                    10.200.235.70            24                94.140.14.49, 94.140.14.59, 1.1.1.1
Loopback Pseudo-Interface 1   127.0.0.1                 8
Loopback Pseudo-Interface 1   127.0.0.1                 8
Npcap Loopback Adapter        169.254.228.70           16
OpenVPN TAP-Windows6          192.168.123.13           24                8.8.8.8, 192.168.0.213
OpenVPN TAP-Windows6          192.168.123.13           24                8.8.8.8, 192.168.0.213
VMware Network Adapter VMnet3 192.168.153.1            24
VMware Network Adapter VMnet4 172.22.154.1             24
```

## Licencia

Este script es de dominio público y puedes usarlo, modificarlo o distribuirlo libremente sin ninguna restricción.
