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
