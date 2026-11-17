<#
.SYNOPSIS
    Reports free space on each local fixed disk.

.DESCRIPTION
    Lists every local fixed disk with its size, free space and percentage free.
    The output is objects, so you can sort it, filter it or export it with Export-Csv.

.EXAMPLE
    .\Get-DiskSpaceReport.ps1

    Lists every fixed disk on this computer.

.EXAMPLE
    .\Get-DiskSpaceReport.ps1 | Where-Object PercentFree -lt 15

    Lists only the disks with less than 15% free.
#>
[CmdletBinding()]
param()

$disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType = 3'

foreach ($disk in $disks) {
    $percentFree = if ($disk.Size -gt 0) {
        [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)
    } else {
        0
    }

    [PSCustomObject]@{
        Drive       = $disk.DeviceID
        SizeGB      = [math]::Round($disk.Size / 1GB, 1)
        FreeGB      = [math]::Round($disk.FreeSpace / 1GB, 1)
        PercentFree = $percentFree
    }
}
