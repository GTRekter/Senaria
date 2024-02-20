param (
    [Parameter(Mandatory = $true)]
    [string]$source_keyvault,

    [Parameter(Mandatory = $true)]
    [string]$destination_keyvault,

    [string[]]$exclude_secrets = @("uat-euw-mwi-redis-merlin-primary-connection-string","uat-euw-mwi-sql-group1-merlin-password", "uat-euw-mwi-sql-group1-merlin-username", "uat-euw-mwi-sql-group2-merlin-password", "uat-euw-mwi-sql-group2-merlin-username")
)

function Is-SecretExcluded {
    param (
        [string]$secretName,
        [string[]]$excludedSecrets
    )
    foreach ($secret in $excludedSecrets) {
        if ($secret -eq $secretName) {
            Write-Host "Secret is excluded: $secretName"
            return $true
        }
    }
    return $false
}

Write-Host "Getting secrets from source Key Vault: $source_keyvault"
$secrets = az keyvault secret list --vault-name $source_keyvault --query "[].id" -o tsv

foreach ($secret_id in $secrets) {
    $secret_name = $secret_id.Split('/')[-1]
    Write-Host "Processing secret: $secret_id"

    if (Is-SecretExcluded -secretName $secret_name -excludedSecrets $exclude_secrets) {
        continue
    }

    Write-Host "Getting secret value for $secret_name..."
    $secret_value = az keyvault secret show --vault-name $source_keyvault --name $secret_name --query "value" -o tsv

    Write-Host "Copying secret to destination Key Vault: $destination_keyvault..."
    az keyvault secret set --vault-name $destination_keyvault --name $secret_name --value $secret_value

    Write-Host "Copied secret: $secret_name"
}

Write-Host "All secrets copied except the excluded ones."
