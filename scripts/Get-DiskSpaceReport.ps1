<#
.SYNOPSIS
    Reports free space on each local fixed disk.

.DESCRIPTION
    Lists every local fixed disk with its size, free space and percentage free.
    The output is objects, so you can sort it, filter it or export it with Export-Csv.
    Disks below the warning threshold are flagged with LowSpace and a warning message.

.PARAMETER WarningThresholdPercent
    Disks with less free space than this percentage are flagged. Defaults to 10.

.EXAMPLE
    .\Get-DiskSpaceReport.ps1

    Lists every fixed disk on this computer and warns about any under 10% free.

.EXAMPLE
    .\Get-DiskSpaceReport.ps1 -WarningThresholdPercent 20 | Where-Object LowSpace

    Lists only the disks with less than 20% free.
#>
[CmdletBinding()]
param(
    [ValidateRange(1, 99)]
    [int]$WarningThresholdPercent = 10
)

$disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType = 3'

foreach ($disk in $disks) {
    $percentFree = if ($disk.Size -gt 0) {
        [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)
    } else {
        0
    }
    $lowSpace = $percentFree -lt $WarningThresholdPercent

    if ($lowSpace) {
        Write-Host "WARNING: $($disk.DeviceID) is down to $percentFree% free"
    }

    [PSCustomObject]@{
        Drive       = $disk.DeviceID
        SizeGB      = [math]::Round($disk.Size / 1GB, 1)
        FreeGB      = [math]::Round($disk.FreeSpace / 1GB, 1)
        PercentFree = $percentFree
        LowSpace    = $lowSpace
    }
}
