
# Get the Recovery Services Vault.
$vault = Get-AzureRmRecoveryServicesVault -Name $vaultName -ResourceGroupName $drResourceGroupName

# Download the vault settings file for the vault.
$vaultsettingsfile = Get-AzureRmRecoveryServicesVaultSettingsFile -Vault $vault -SiteRecovery -Path "$PSScriptRoot"

# Import the vault settings file to set the vault context for the PowerShell session.
Import-AzureRmRecoveryServicesAsrVaultSettingsFile -Path $vaultsettingsfile.FilePath

# Delete the downloaded vault settings file.
Remove-Item -Path $vaultsettingsfile.FilePath

# Create a protection container in the primary Azure region (within the Primary fabric).
Write-Output "Creating primary protection container"
$primaryProtectionContainer = New-ASRProtectionContainer $primaryLocation $primaryName

# Create a protection container in the DR Azure region (within the DR fabric).
Write-Output "Creating DR protection container"
$drProtectionContainer = New-ASRProtectionContainer $drLocation $drName

# Create a replication policy.
Write-Output "Creating a replication policy"
$tempASRJob = New-ASRPolicy -AzureToAzure -Name $replicationPolicyName `
    -RecoveryPointRetentionInHours 24 -ApplicationConsistentSnapshotFrequencyInHours 4
Check-ASRJob $tempASRJob
$replicationPolicy = Get-ASRPolicy -Name $replicationPolicyName

# Create a protection container mapping for failover.
Write-Output "Creating a protection container mapping for failover"
$tempASRJob = New-ASRProtectionContainerMapping -Name "primary-to-dr" -Policy $replicationPolicy `
    -PrimaryProtectionContainer $primaryProtectionContainer -RecoveryProtectionContainer $drProtectionContainer
Check-ASRJob $tempASRJob

$EusToWusPCMapping = Get-ASRProtectionContainerMapping -ProtectionContainer $PrimaryProtContainer -Name "A2APrimaryToRecovery"

# Create a protection container mapping for failback.
Write-Output "Creating a protection container mapping for failback"
$tempASRJob = New-ASRProtectionContainerMapping -Name "dr-to-primary" -Policy $replicationPolicy `
    -PrimaryProtectionContainer $drProtectionContainer -RecoveryProtectionContainer $primaryProtectionContainer
Check-ASRJob $tempASRJob

# Create a network mapping for failover.
$tempASRJob = New-ASRNetworkMapping -AzureToAzure -Name "primary-to-dr" -PrimaryFabric $primaryFabric `
 -PrimaryAzureNetworkId $EastUSPrimaryNetwork 
 -RecoveryFabric $RecoveryFabric -RecoveryAzureNetworkId $WestUSRecoveryNetwork





  #Create Cache storage account for replication logs in the primary region
$EastUSCacheStorageAccount = New-AzureRmStorageAccount -Name "a2acachestorage" -ResourceGroupName "A2AdemoRG" -Location 'East US' -SkuName Standard_LRS -Kind Storage

#Create a Recovery Network in the recovery region
$WestUSRecoveryVnet = New-AzureRmVirtualNetwork -Name "a2arecoveryvnet" -ResourceGroupName "a2ademorecoveryrg" -Location 'West US 2' -AddressPrefix "10.0.0.0/16"

Add-AzureRmVirtualNetworkSubnetConfig -Name "default" -VirtualNetwork $WestUSRecoveryVnet -AddressPrefix "10.0.0.0/20" | Set-AzureRmVirtualNetwork

$WestUSRecoveryNetwork = $WestUSRecoveryVnet.Id

#Retrieve the virtual network that the virtual machine is connected to

 #Get first network interface card(nic) of the virtual machine
 $SplitNicArmId = $VM.NetworkProfile.NetworkInterfaces[0].Id.split("/")

 #Extract resource group name from the ResourceId of the nic
 $NICRG = $SplitNicArmId[4]

 #Extract resource name from the ResourceId of the nic
 $NICname = $SplitNicArmId[-1]

 #Get network interface details using the extracted resource group name and resource name
 $NIC = Get-AzureRmNetworkInterface -ResourceGroupName $NICRG -Name $NICname

 #Get the subnet ID of the subnet that the nic is connected to
 $PrimarySubnet = $NIC.IpConfigurations[0].Subnet

 # Extract the resource ID of the Azure virtual network the nic is connected to from the subnet ID
 $EastUSPrimaryNetwork = (Split-Path(Split-Path($PrimarySubnet.Id))).Replace("\","/")

 #Create an ASR network mapping between the primary Azure virtual network and the recovery Azure virtual network
 $TempASRJob = New-ASRNetworkMapping -AzureToAzure -Name "A2AEusToWusNWMapping" -PrimaryFabric $PrimaryFabric -PrimaryAzureNetworkId $EastUSPrimaryNetwork -RecoveryFabric $RecoveryFabric -RecoveryAzureNetworkId $WestUSRecoveryNetwork

 #Track Job status to check for completion
 while (($TempASRJob.State -eq "InProgress") -or ($TempASRJob.State -eq "NotStarted")){
         sleep 10;
         $TempASRJob = Get-ASRJob -Job $TempASRJob
 }

 #Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
 Write-Output $TempASRJob.State

 #Create an ASR network mapping for failback between the recovery Azure virtual network and the primary Azure virtual network
$TempASRJob = New-ASRNetworkMapping -AzureToAzure -Name "A2AWusToEusNWMapping" -PrimaryFabric $RecoveryFabric -PrimaryAzureNetworkId $WestUSRecoveryNetwork -RecoveryFabric $PrimaryFabric -RecoveryAzureNetworkId $EastUSPrimaryNetwork

#Track Job status to check for completion
while (($TempASRJob.State -eq "InProgress") -or ($TempASRJob.State -eq "NotStarted")){
        sleep 10;
        $TempASRJob = Get-ASRJob -Job $TempASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $TempASRJob.State
