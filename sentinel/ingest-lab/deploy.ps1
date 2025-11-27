# deploy.ps1
$resourceGroup = "rg-sec-test"
$vmName = "sentinelvm01"
$dcrName = "sentinel-dcr"
$dcrFile = "patched-dcr.json"
$workspaceId = "aff3222e-4ac7-466c-8db6-a2f80c32278b"

Write-Host "Recreating DCR..."
az monitor data-collection rule delete `
  --name $dcrName `
  --resource-group $resourceGroup --yes 2>$null

az monitor data-collection rule create `
  --name $dcrName `
  --resource-group $resourceGroup `
  --location eastus2 `
  --rule-file $dcrFile

Write-Host "Reassociating DCR with VM..."
az monitor data-collection rule association create `
  --name "$dcrName-association" `
  --rule "/subscriptions/95f5b230-2ac0-46e4-9e78-213a57b19bda/resourceGroups/$resourceGroup/providers/Microsoft.Insights/dataCollectionRules/$dcrName" `
  --resource "/subscriptions/95f5b230-2ac0-46e4-9e78-213a57b19bda/resourceGroups/$resourceGroup/providers/Microsoft.Compute/virtualMachines/$vmName"

Write-Host "Installing Azure Monitor Agent..."
az vm extension set `
  --name AzureMonitorWindowsAgent `
  --publisher Microsoft.Azure.Monitor `
  --vm-name $vmName `
  --resource-group $resourceGroup `
  --settings "{`"workspaceId`": `"$workspaceId`"}"

Write-Host "Deployment complete."
