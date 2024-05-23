
<#
    .USAGE

    get object ID for Ravnur Managed-Identity and supply the objectid param
    .\add-roleassignments.ps1 -env "<your env>" -objectid "<object ID for Ravnur Managed Identity in Ravnur Managed Resource Group>" -rgname "<rg name>" -storageaccountname "<storage account where you want to grant the IAM roles>"



    .PARAMETER env
        Specifies the environment to log into

    .PARAMETER objectid
        This is the object ID for the Managed Identity located in the Ravnur Managed Resource group, named like: id-rms-xxxxxxxx.
        Copy the Object (principal) ID from this resource to populate the variable

    .PARAMETER rgname
        Specifies the resource group that houses the storage account where we want to apply the IAM role assignments for the Ravnur Managed Identity.

    .PARAMETER storageaccountname
        Specifies the storage account where we want to apply the IAM role assignments for the Ravnur Managed Identity.
        
#>


param(
    [string]$env,
    [string]$objectid,
    [string]$rgname,
    [string]$storageaccountname
)


# Array of roles to assign
$roles = @("Reader", "Storage Blob Data Contributor", "Storage Blob Delegator", "Storage Table Data Contributor")

# Get the resource ID for the storage account so we can use it for the scope param
$scope = (Get-AzStorageAccount -ResourceGroupName $rgname -Name $storageaccountname).id

# Iterate through each role and assign it
foreach ($roleName in $roles) {
    # Check if the role assignment already exists
    try {
        $existingAssignment = Get-AzRoleAssignment -ObjectId $objectid -RoleDefinitionName $roleName -Scope $scope -ErrorAction Stop
    }
    catch {
        $existingAssignment = $null
    }

    # If the role assignment doesn't exist, create it
    if (-not $existingAssignment) {
        try {
            # Assign role
            New-AzRoleAssignment -ObjectId $objectid -RoleDefinitionName $roleName -Scope $scope -ErrorAction Stop
            Write-Host "Role assignment for $($roleName) created successfully."
        }
        catch {
            Write-Host "Failed to create role assignment for $($roleName): $($_.Exception.Message)"
        }
    }
    else {
        Write-Host "Role assignment for $($roleName) already exists."
    }
}

