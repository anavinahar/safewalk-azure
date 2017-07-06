Import-Module AzureRM

$serverVHD = "/powershell/az1Safewalk.vhd"
$gatewayVHD = "/powershell/azSWGateway.vhd"
$templatePath = '/powershell/customvhd.json'
$rgn = 'sfwlk'
$loc = 'southcentralus'
$subnetName = "mySubNet"
$vnetName = "myVnetName"
$password = '!Q2w3e4r5t6y'
$gatewayURI = "https://$rgn.blob.core.windows.net/mycontainer/safewalkGateway.vhd"
$serverURI = "https://$rgn.blob.core.windows.net/mycontainer/safewalkServer.vhd"

New-AzureRmResourceGroup -Name $rgn -Location $loc
New-AzureRmStorageAccount -ResourceGroupName $rgn -Name $rgn -Location $loc -SkuName "Standard_LRS" -Kind "Storage"
#Add-AzureRmVhd -ResourceGroupName $rgn -Destination $gatewayURI -LocalFilePath $gatewayVHD
#Add-AzureRmVhd -ResourceGroupName $rgn -Destination $serverURI -LocalFilePath $serverVHD

$params = @{
    storageRoot = $rgn
    vmPrefix = $rgn
    createVnet = $false
    vNetResourceGroup = $rgn
    vNetName = $vnetName
    subnetName = $subnetName
    vNetAddressSpace = "10.0.0.0/16"
    subnetAddressSpace = "10.0.0.0/24"
    gatewayIP = "10.0.0.4"
    serverIP = "10.0.0.5"
    vmPassword = (ConvertTo-SecureString -AsPlainText -Force $password) 
}
New-AzureRmResourceGroupDeployment -Name customVHD -ResourceGroupName $rgn -TemplateFile $templatePath @params -Verbose

#Cli commands
serverVHD=@az1Safewalk.vhd
gatewayVHD=@azSWGateway.vhd
rgn=taboada
loc=southcentralus
subnetName=mySubNet
vnetName=myVnetName
#password=\!Q2w3e4r5t6y
#gatewayURI=https://$rgn.blob.core.windows.net/mycontainer/safewalkGateway.vhd
#serverURI=https://$rgn.blob.core.windows.net/mycontainer/safewalkServer.vhd
az group create -l $loc -n $rgn
az storage account create -n $rgn -g $rgn -l $loc --sku Standard_LRS

#STORAGE_KEY=$(az storage account keys list -g $rgn -n $rgn --query "[?keyName=='key1'] | [0].value" -o tsv)
az storage container create -n $rgn --account-name $rgn #--account-key ${STORAGE_KEY}
az storage blob upload --account-name tabu$rgn --container-name $rgn --file $gatewayVHD --type page --name safewalkGateway.vhd
az storage blob upload --account-name tabu$rgn --container-name $rgn --file $serverVHD --type page --name safewalkServer.vhd

az group deployment validate --resource-group $rgn --template-file customvhd.json --parameters @parameters.json
az group deployment create --name $rgn --resource-group $rgn --template-file customvhd.json --parameters @parameters.json


vm extension set --resource-group $rgn --vm-name safewalkale-gateway  --name customScript --publisher Microsoft.Azure.Extensions --settings @gateway-command.json