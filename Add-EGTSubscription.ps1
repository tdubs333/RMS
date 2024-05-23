
<#
    .USAGE

    .\Add-EGTSubscription.ps1 -env "<your env>" -sbrgname "<rg that houses your service bus>" -sbname "<service bus name>" -location_naming_convention "<some az region>" -egtrgname "<ravnur Managed RG that houses the RMS eventgrid topic>" -topicname "eg-topic-rms-xxxxxxx"

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

# Get resource id for sb queue
$sbqueue = Get-AzServiceBusQueue -ResourceGroupName $sbrgname -NamespaceName $sbname -Name "<your SB queue name here>"
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
