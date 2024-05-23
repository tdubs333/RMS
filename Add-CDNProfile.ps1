<#
    .USAGE

    STG
        .\Add-CDNProfile.ps1 -env "stg" -rgname "amsstguswest-rg"

    PROD
        .\Add-CDNProfile.ps1 -env "prod" -rgname "amsproduswest-rg"

    .PARAMETER env
        Specifies the environment to log into

    .PARAMETER rgname
        Specifies the resource group where we want to create the CDN profile

#>


param (
    [string]$env,
    [string]$rgname
)

try {
    # Define other variables
    $location = "global"
    $cdnProfileName = "cdn-$env-rms"   
    $sku = "Premium_Verizon"

    # Tags (replace with appropriate key/value pairs)
    $tags = @{
        "environment"          = "$env"
        "project"              = "ams_video_migration"
        "business_criticality" = "$env-critical"
        "owner"                = "BNSK Operations"
    }

    # Create a CDN profile
    New-AzCdnProfile -ResourceGroupName $rgname -ProfileName $cdnProfileName -Location $location -SkuName $sku -Tag $tags -ErrorAction Stop

    Write-Host "CDN profile created successfully." -ForegroundColor Green
} 
catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
}
