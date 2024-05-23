<#

    .USAGE

    .TEST
        .\Add-CDNEndpoint.ps1 -Env "<your env>" -RGName "<RG where you want to create the CDN>" -ProfileName "<CDN profile name of your choosing>" -OriginHostHeader "<some url>" -OriginName "<ravnur-instance-endpoint-url-with-dashes>" -OriginHostName "<some url>" -endpointname "<some storage account name>"

    

    
    .PARAMETER OriginName
        Specifies the name assigned to the origin server from which content will be delivered. In this case a custom origin / the Ravnur endpoint url with dashes.      
        e.g; fd-xxxxx-xxxx-a03-azurefd-net 
        
    .PARAMETER OriginHostName
        Specifies the hostname of the origin server from which content will be retrieved. In this case the RMS instance Endpoint URL
        e.g; fd-xxxxx-xxxx.a03.azurefd.net  

    .PARAMETER OriginHostHeader
        Specifies the host header value to be used when communicating with the origin server. In this case the RMS instance Endpoint URL
        e.g; fd-xxxxx-xxxx.a03.azurefd.net

    .PARAMETER EndpointName
        Specifies the name of the CDN endpoint
        e.g; somestorage-region.azureedge.net  
   
    
#>

param (
    [string]$rgname,
    [string]$profilename,
    [string]$OriginHostHeader,
    [string]$OriginName,
    [string]$OriginHostName,
    [string]$endpointName
)

# Check if the endpoint already exists, create one if it doesn't
$existingEndpoint = Get-AzCdnEndpoint -ResourceGroupName $rgname -ProfileName $profilename -Name $endpointName -ErrorAction SilentlyContinue

if ($existingEndpoint) {
    Write-Host "Endpoint '$EndpointName' already exists."
}
else {
    $Origin = @{
        Name     = $OriginName
        HostName = $OriginHostName
    }
    New-AzCdnEndpoint -ResourceGroupName $RGName -ProfileName $ProfileName -Name $EndpointName -Location westus -Origin $Origin -OriginHostHeader $OriginHostHeader -OptimizationType "GeneralWebDelivery"
    Write-Host "Endpoint '$EndpointName' created successfully."
}
