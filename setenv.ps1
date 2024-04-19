param (
    [Parameter(Mandatory=$true)]
    [string]$resourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$webappName
)

# Initialize an empty hashtable to collect settings
$settings = @{}

# Read each line from the .env file
Get-Content .\.env | ForEach-Object {
    # Split the line into key and value based on the '=' delimiter
    $keyValue = $_.Split('=', 2)  # Split into at most two parts to handle values containing '='
    $key = $keyValue[0].Trim()
    $value = $keyValue[1].Trim()

    # Add to settings hashtable
    $settings[$key] = $value
}

# Convert the hashtable to an array of settings strings for the Azure CLI
$settingsArray = $settings.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }

# Join the array into a single string with spaces separating each setting
$settingsString = $settingsArray -join " "

# Use the Azure CLI to set the environment variables in your web app
az webapp config appsettings set --resource-group $resourceGroup --name $webappName --settings WEBSITE_WEBDEPLOY_USE_SCM=false $settingsString
