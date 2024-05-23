<#
    .USAGE

    STG
        .\Add-ServiceBusEventQueue.ps1 -env "stg" -rgname "Default-ServiceBus-EastUS" -namespacename "bskservicebusstg"

    PROD
        .\Add-ServiceBusEventQueue.ps1 -env "prod" -rgname "Default-ServiceBus-EastUS" -namespacename "bskservicebusprod"

    .PARAMETER env
        Specifies the azure sub to log into 

    .PARAMETER rgname
        Specifies the reource group that holds the service bus namespace where we want to create the queue.

    .PARAMETER namespacename
        Specifies the service bus namespace  where we want to create the queue.
    

#>


param (
    [string]$env,
    [string]$rgname,
    [string]$namespacename
)

# Connect to Azure
Connect-AzAccount -Subscription "brainshark - $env"

# Get the subscription ID from the context
$subscriptionID = (Get-AzContext).Subscription.Id

# Set other variables
$queueName = "rmseventq"

# Check if the queue already exists
$existingQueue = Get-AzServiceBusQueue -ResourceGroupName $rgname -Namespace $namespaceName -Name $queueName -ErrorAction SilentlyContinue

if ($existingQueue -ne $null) {
    Write-Host "An event queue with the name '$queueName' already exists in the Azure Service Bus."
}
else {
    # Create a new queue
    $queueParams = @{
        ResourceGroupName = $rgname
        NamespaceName     = $namespaceName
        QueueName         = $queueName
    }

    New-AzServiceBusQueue @queueParams

    Write-Host "Event queue '$queueName' has been successfully created in the Azure Service Bus."
}
