#Requires -Version 5.1
#Requires -Modules Az.Profile
function Get-AzBearerTokenToClipBoard {
    [CmdletBinding()]
    param()
    Begin {
        [System.Management.Automation.ActionPreference]$LastEAPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'

        try {
            Get-AzBearerToken | Set-Clipboard
        }
        finally {
            $ErrorActionPreference = $LastEAPreference
        }
    }
}