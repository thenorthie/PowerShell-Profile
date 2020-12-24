﻿<#
.Synopsis
    Install the TsekNet PowerShell profile.

.DESCRIPTION
    Install the TsekNet PowerShell profile from GitHub for the desired scope.
    By default, the existing profile will not be overwritten.

.Parameter Scope
    Name of the PowerShell profile scope to use.
    See https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles for more information.

.Parameter URL
    Fully qualified URL to the profile.ps1 file to download.

.EXAMPLE
    Overwrite the AllUsersAllHosts PowerShell Profile with data downloaded from the URL.
    .\install.ps1 -Scope 'AllUsersAllHosts' -URL 'http://example.com'
#>
[CmdletBinding()]
param(
  [ValidateSet('AllUsersAllHosts', 'AllUsersCurrentHost', 'CurrentUserAllHosts', 'CurrentUserCurrentHost')]
  [string]$Scope = "CurrentUserAllHosts",
  [Uri]$URL = 'https://github.com/thenorthie/PowerShell-Profile/raw/master/profile.ps1'
)

$profile_dir = Split-Path $PROFILE.$Scope
$profile_file = $profile.$Scope
$request = Invoke-WebRequest $URL -UseBasicParsing  -ContentType "text/plain; charset=utf-8"

if (-not (Test-Path $profile_dir)) {
  New-Item -Path $profile_dir -ItemType Directory | Out-Null
  Write-Verbose "Created new profile directory: $profile_dir"
}

# Leverage IO.File for PowerShell 5 comppatability.
[IO.File]::WriteAllLines($profile_file, $request.Content)
Write-Verbose "Wrote profile file: $profile_file with content from: $URL"
& $profile_file -Verbose

Install-Module -Name "azuread" -Confirm:$False -Force
Install-Module -Name "MicrosoftTeams" -Confirm:$False -Force
