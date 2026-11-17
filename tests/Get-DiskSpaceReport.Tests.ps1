BeforeAll {
    $script:ScriptPath = "$PSScriptRoot/../scripts/Get-DiskSpaceReport.ps1"

    # Get-CimInstance only exists on Windows, but CI runs on Linux.
    # This stand-in gives Pester something to mock there. The mocks replace it, so it never runs.
    if (-not (Get-Command Get-CimInstance -ErrorAction SilentlyContinue)) {
        function global:Get-CimInstance {
            param($ClassName, $Filter)
            throw "Get-CimInstance isn't available on this platform (asked for $ClassName where $Filter)."
        }
    }
}

Describe 'Get-DiskSpaceReport' {
    BeforeEach {
        # Fake disks, so the tests never depend on the machine running them.
        Mock Get-CimInstance {
            [PSCustomObject]@{ DeviceID = 'C:'; Size = 100GB; FreeSpace = 25GB }
            [PSCustomObject]@{ DeviceID = 'D:'; Size = 200GB; FreeSpace = 10GB }
        }
    }

    It 'returns one result per disk' {
        $result = & $script:ScriptPath
        $result.Count | Should -Be 2
    }

    It 'calculates the percentage free' {
        $c = & $script:ScriptPath | Where-Object Drive -EQ 'C:'
        $c.PercentFree | Should -Be 25
    }

    It 'reports sizes in GB' {
        $d = & $script:ScriptPath | Where-Object Drive -EQ 'D:'
        $d.SizeGB | Should -Be 200
        $d.FreeGB | Should -Be 10
    }

    It 'handles a disk that reports zero size' {
        Mock Get-CimInstance {
            [PSCustomObject]@{ DeviceID = 'E:'; Size = 0; FreeSpace = 0 }
        }
        $e = & $script:ScriptPath
        $e.PercentFree | Should -Be 0
    }
}
