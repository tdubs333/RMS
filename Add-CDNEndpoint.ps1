<#

    .USAGE

    .TEST
        .\Add-CDNEndpoint.ps1 -Env "qaz1" -RGName "bsk-ams-uswest-rgroup-qa-01" -ProfileName "cdn-qaz1-rms-3" -OriginHostHeader "im.toobigforthisband.com" -OriginName "<ravnur-instance-endpoint-url-with-dashes>" -OriginHostName "im.toobigforthisband.com" -endpointname "somestorageacct-uswe"

    .STG
        .\Add-CDNEndpoint.ps1 -Env "stg" -RGName "amsstguswest-rg" -ProfileName "cdn-stg-rms" -OriginHostHeader "<RMS instance Endpoint URL here>" -OriginName "<ravnur-instance-endpoint-url-with-dashes>" -OriginHostName "<RMS instance Endpoint URL here>" -endpointname "rmsstguswest-uswe"

    .PROD
        .\Add-CDNEndpoint.ps1 -Env "prod" -RGName "amsproduswest-rg" -ProfileName "cdn-prod-rms" -OriginHostHeader "<RMS instance Endpoint URL here>" -OriginName "<ravnur-instance-endpoint-url-with-dashes>" -OriginHostName "<RMS instance Endpoint URL here>" -endpointname "rmsproduswest-uswe"

    
    .PARAMETER OriginName
        Specifies the name assigned to the origin server from which content will be delivered. In this case a custom origin / the Ravnur endpoint url with dashes.      
        e.g; fd-jntcnd6ole7lc-avb6ancmd7b5gjcr-a03-azurefd-net  (qaz1)
        
    .PARAMETER OriginHostName
        Specifies the hostname of the origin server from which content will be retrieved. In this case the RMS instance Endpoint URL
        e.g; fd-jntcnd6ole7lc-avb6ancmd7b5gjcr.a03.azurefd.net (qaz1)

    .PARAMETER OriginHostHeader
        Specifies the host header value to be used when communicating with the origin server. In this case the RMS instance Endpoint URL
        e.g; fd-jntcnd6ole7lc-avb6ancmd7b5gjcr.a03.azurefd.net

    .PARAMETER EndpointName
        Specifies the name of the CDN endpoint
        e.g; bskrmsqauswest-uswe.azureedge.net (qaz1)
    
    
    .NOTES 

    the endpoint host format was reused from what we had with ams 
 
    otherwise the host name will have to be changed in all the configuration, including admin data

    we ultimately put into the ravnur streaming endpoint field what we chose in the cdn creation

#>

param (
    [string]$rgname,
    [string]$profilename,
    [string]$OriginHostHeader,
    [string]$OriginName,
    [string]$OriginHostName,
    [string]$endpointName
)

# Check if the endpoint already exists
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