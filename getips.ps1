# Obtener las interfaces de red activas
$interfaces = Get-NetIPInterface -ConnectionState Connected

# Crear una tabla vacía
$table = @()

# Recorrer cada interfaz
foreach ($interface in $interfaces) {

    # Obtener la dirección IP, la máscara de red y el gateway
    $ipaddress = Get-NetIPAddress -InterfaceIndex $interface.InterfaceIndex -AddressFamily IPv4

    # Obtener los servidores DNS
    $dns = Get-DnsClientServerAddress -InterfaceIndex $interface.InterfaceIndex -AddressFamily IPv4

    # Crear un objeto con los datos de la interfaz
    $object = [PSCustomObject]@{
        InterfaceAlias = $interface.InterfaceAlias
        IPAddress = $ipaddress.IPAddress
        PrefixLength = $ipaddress.PrefixLength
        DefaultGateway = $ipaddress.DefaultGateway
        DNSServer = $dns.ServerAddresses -join ", "
    }

    # Agregar el objeto a la tabla
    $table += $object
}

# Imprimir la tabla ordenada por alias de interfaz
$table | Sort-Object InterfaceAlias | Format-Table -AutoSize