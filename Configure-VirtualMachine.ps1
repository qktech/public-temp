# Format our data disk if it hasn't been formatted already.
if (!(Test-Path S:)) {
    Get-Disk |
        Where-Object PartitionStyle -eq 'RAW' |
        Initialize-Disk -PartitionStyle GPT -PassThru |
        New-Partition -DriveLetter S -UseMaximumSize |
        Format-Volume -FileSystem NTFS -Confirm:$false
}

# Always (re)install the latest version of Seq:
Invoke-WebRequest -Uri 'https://getseq.net/Download/Begin?version=latest' -OutFile "$env:temp\seq-latest.msi"
Start-Process "msiexec.exe" -ArgumentList "/i `"$env:temp\seq-latest.msi`" /quiet /norestart /lv `"$env:temp\seq-latest.log`"" -Wait

# Install the Windows service if it hasn't been installed already.
if (!(Test-Path S:\Seq)) {
    Start-Process "C:\Program Files\Seq\Seq.exe" -ArgumentList "install --storage=`"S:\Seq`"" -Wait
}

# TODO: Add the f/w rule if it hasn't been added already

Start-Process "C:\Program Files\Seq\Seq.exe" -ArgumentList "start" -Wait