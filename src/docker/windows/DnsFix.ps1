# this is a workaround for dns issues with Windows Containers in ACI
$dnsClientSettings = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object -FilterScript { $_.ElementName -NotLike "Loopback*" }
$dnsClientSettings | Set-DnsClientServerAddress -ServerAddresses @('8.8.8.8', '8.8.4.4')