param(
    [string]$prefix = "wudotnet-01a18ad1",
    [string]$location = "Central US",
    [switch]$deleteOnly
) 

$resourceGroupNames = @(
    "$prefix-nonprod",
    "$prefix-prod"
)

foreach($resourceGroupName in $resourceGroupNames)
{
    $exists = az group exists --name $resourceGroupName | ConvertFrom-Json
    if($exists)
    {
        Write-Host "Deleting resource group $resourceGroupName"
        az group delete --name $resourceGroupName --yes
    }

    if(!($deleteOnly))
    {
        Write-Host "Creating resource group $resourceGroupName"
        az group create --name $resourceGroupName --location $location
    }
}