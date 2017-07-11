#Cli commands
#serverVHD=@az1Safewalk.vhd
gatewayVHD=../ISO/GatewayAzure.vhd
rgn=safewalkale
loc=southcentralus
#subnetName=mySubNet
#vnetName=myVnetName
#password=\!Q2w3e4r5t6y

az group create -l $loc -n $rgn
az storage account create -n $rgn -g $rgn -l $loc --sku Standard_LRS

#STORAGE_KEY=$(az storage account keys list -g $rgn -n $rgn --query "[?keyName=='key1'] | [0].value" -o tsv)
az storage container create -n $rgn --account-name $rgn #--account-key ${STORAGE_KEY}
az storage blob upload --account-name $rgn --container-name $rgn --file $gatewayVHD --type page --name safewalkGateway.vhd
#az storage blob upload --account-name $rgn --container-name $rgn --file $serverVHD --type page --name safewalkServer.vhd

#az group deployment validate --resource-group $rgn --template-file customvhd.json --parameters @parameters.json
#az group deployment create --name $rgn --resource-group $rgn --template-file customvhd.json --parameters @parameters.json


#vm extension set --resource-group $rgn --vm-name safewalkale-gateway  --name customScript --publisher Microsoft.Azure.Extensions --settings @gateway-command.json