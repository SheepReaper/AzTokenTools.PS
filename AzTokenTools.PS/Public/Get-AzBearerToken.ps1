#Requires -Version 5.1
#Requires -Modules Az.Profile
function Get-AzBearerToken {
    [CmdletBinding()]
    param()
    Begin {
        [System.Management.Automation.ActionPreference]$LastEAPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'

        try {
            "Bearer $(Get-AzCachedAccessToken)"
        }
        finally {
            $ErrorActionPreference = $LastEAPreference
        }
    }
}