<#
    .USAGE

    STG
        .\Add-CDNProfile.ps1 -env "<your env>" -rgname "<rg where you want to land the resource>"

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
    # Define other variables - or make them params if you like
    $location = "global"
    $cdnProfileName = "cdn-$env-rms"   
    $sku = "Premium_Verizon"

    # Tags - be a good citizen and add tags. Your operations team will thank you.  
    $tags = @{
        "environment"          = "$env"
    }

    # Create a CDN profile
    New-AzCdnProfile -ResourceGroupName $rgname -ProfileName $cdnProfileName -Location $location -SkuName $sku -Tag $tags -ErrorAction Stop

    Write-Host "CDN profile created successfully." -ForegroundColor Green
} 
catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
}
