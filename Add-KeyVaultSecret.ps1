<#

    This script presupposes a JSON file located on your local workstation (or a share as you prefer). JSON should contain the following:

    {
	"AccountName": "default",
	"ResourceGroup": "<RMS Managed RG Name>",
	"SubscriptionId": "<your azure subscription ID>",
	"ApiEndpoint": "<RMS Console URL>",
	"ApiKey": "<RMS Console API Key>"
    }

    .USAGE

 
    .\Add-KeyVaultSecret.ps1 -SubscriptionId "<subscription id for your azure sub>" -KeyVaultName "<your KV name>" -ResourceGroupName "<KV RG name>" -SecretName "<your chosen secret name>" -JsonFilePath "<path to json file>"


    .PARAMETER SubscriptionId
        Specifies the azure subscription to log into
    
    .PARAMETER ResourceGroupName
        Specifies the RG that houses the Keyvault where we want to create the secret

    .PARAMETER KeyVaultName
        Specifies the Keyvault where we want to create the secret

    .PARAMETER SecretName
        The name of the scret we want to create

    .PARAMETER JsonFilePath
        Specifies the path to the file that contains the JSON to be used as the secret contents
    
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $true)]
    [string]$KeyVaultName,

    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$SecretName,

    [Parameter(Mandatory = $true)]
    [string]$JsonFilePath
)

try {

    # Authenticate to Azure using the provided subscription ID
    Connect-AzAccount -Subscription $SubscriptionId

    # Get the subscription ID
    $subscriptionID = (Get-AzContext).Subscription.Id

    # Get the Key Vault
    $keyVault = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName

    # Check if the secret already exists
    $existingSecret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $SecretName -ErrorAction SilentlyContinue
    if ($existingSecret -ne $null) {
        Write-Host "Secret '$SecretName' already exists in Key Vault '$KeyVaultName'."
        exit
    }

    # Read the JSON content from the file
    $jsonContent = Get-Content -Path $JsonFilePath -Raw

    # Convert the JSON content to a secure string
    $secureJsonContent = ConvertTo-SecureString -String $jsonContent -AsPlainText -Force

    # Set the secret in the Key Vault
    $secret = Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $SecretName -SecretValue $secureJsonContent

    # Output the secret object
    $secret
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}
