
<#
    .USAGE

    QAZ2
        .\Add-EGTSubscription.ps1 -env "QAZ2" -sbrgname "rg-bsk-qaz2-eastus" -sbname "sb-qaz2-eastus" -location_naming_convention "eastus" -egtrgname "rg-bsk-qaz2-rms-managed-eastus" -topicname "eg-topic-rms-73xtei2qmja7s"

    STG
        .\Add-EGTSubscription.ps1 -env "STG" -sbrgname "Default-ServiceBus-EastUS" -sbname "bskservicebusstg" -location_naming_convention "westus" -egtrgname "rg-bsk-stg-rms-managed-eastus" -topicname "eg-topic-rms-xxxx"

    PROD
        .\Add-EGTSubscription.ps1 -env "PROD" -sbrgname "Default-ServiceBus-EastUS" -sbname "bskservicebusprod" -location_naming_convention "westus" -egtrgname "rg-bsk-prod-rms-managed-eastus" -topicname "eg-topic-rms-xxxx"

    .PARAMETER  sbrgname
        Specifies the resource group that houses the service bus.

    .PARAMETER  sbname
        Specifies the name of the service bus.

    .PARAMETER  egtrgname
        Specifies the Ravnur managed resource group that houses the eventgrid topic.
    
    .PARAMETER  topicname
        Specifies the named of the eventgrid topic in the Ravnur managed resource group.

    .PARAMETER env
        Specifies the environment - can be used for azure sub or resource naming purposes. 

    .PARAMETER location_naming_convention
        Specifies the location where resources will be deployed - used for resource naming.

#>


param (
    [string]$env,
    [string]$sbrgname,
    [string]$egtrgname,
    [string]$sbname,
    [string]$location_naming_convention,
    [string]$topicname
)

if($env -match "QAZ"){
    Connect-AzAccount -Subscription "brainshark - qa"
}
else {
    Connect-AzAccount -Subscription "brainshark - $env"
}


# Get resource id for sb queue
$sbqueue = Get-AzServiceBusQueue -ResourceGroupName $sbrgname -NamespaceName $sbname -Name "rmseventq"
$endpoint = $sbqueue.Id

# Check if the EventGrid topic subscription exists, create one if it doesn't
$subscription = Get-AzEventGridSubscription -ResourceGroupName $egtrgname -TopicName $topicName -EventSubscriptionName "evs-$env-rms-$location_naming_convention" -ErrorAction SilentlyContinue

if ($subscription) {
    Write-Host "Subscription found. Exiting."
}
else {
    write-host -fore yellow "evs-$env-rms-$location_naming_convention not found in eventgrid topic, creating it now"
    # Create topic subscription
    New-AzEventGridSubscription -ResourceGroup $egtrgname -TopicName $topicname -EndpointType 'servicebusqueue' -Endpoint $endpoint -EventSubscriptionName "evs-$env-rms-$location_naming_convention"
    Write-Host "Event Grid subscription created successfully."
}