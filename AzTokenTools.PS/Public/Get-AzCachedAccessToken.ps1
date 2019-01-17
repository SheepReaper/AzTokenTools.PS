#Requires -Version 5.1
#Requires -Modules Az.Profile

<#
.SYNOPSIS
Get an AAD Access Token. Must have signed in previously.
.DESCRIPTION
Get an AAD Access Token without needing to specify a ResourceId or ClientId. Ensure that you have run Connect-AzureRmAccount prior to running this command. 
.OUTPUTS
System.String. Get-Token returns an AAD Bearer Token in Base64 encoded string format.
#>
function Get-AzCachedAccessToken {
    [CmdletBinding()]
    param()
    Begin {
        [System.Management.Automation.ActionPreference]$LastEAPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
        try {
            [Microsoft.Azure.Commands.Common.Authentication.Models.AzureRmProfile]$azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
            if (-not $azureRmProfile.Accounts.Count) {
                throw [AccessViolationException]::new()
            }

            [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]$currentAzureContext = Get-AzContext
            [Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient]$profileClient = [Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient]::new($azureRmProfile)

            [string]$tenantId = $currentAzureContext.Tenant.TenantId
            
            Write-verbose "Getting access token for tenant $tenantId"

            $profileClient.AcquireAccessToken($tenantId).AccessToken
        }
        catch [AccessViolationException] {
            Write-Error `
                -Exception $PSItem.Exception `
                -Message "An AzureRm Profile Instance was not found. Ensure that you have logged in before calling this cmdlet."
        }
        catch {
            Write-Error `
                -Exception $PSItem.Exception `
                -Message "Something went wrong $($PSItem.Exception.Message)"
        }
        finally {
            $ErrorActionPreference = $LastEAPreference
        }
    }
}