<#
    .USAGE

    STG
        .\Add-ServiceBusEventQueue.ps1 -env "<your env>" -rgname "<your service bus RG>" -namespacename "<your service bus namespace>"

    .PARAMETER rgname
        Specifies the reource group that holds the service bus namespace where we want to create the queue.

    .PARAMETER namespacename
        Specifies the service bus namespace  where we want to create the queue.
    

#>


param (
    [string]$rgname,
    [string]$namespacename
)


# Set other variables - or make this a param if you like
$queueName = "<your desired queue name>"

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
