# *****************************************************************************
#
# File:        06-CreateDR.ps1
#
# Description: Creates the primary environment.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
# *****************************************************************************

# Get script variables.
. $PSScriptRoot\00-ScriptVariables.ps1

$vaultName = $drResourceGroupName.ToLower() + "-rsv"
$primaryVNetName = $primaryResourceGroupName.ToLower() + "-vnet"
$drVnetName = $drResourceGroupName.ToLower() + "-vnet"

function Check-ASRJob {
    param([Microsoft.Azure.Commands.RecoveryServices.SiteRecovery.ASRJob]$asrJob)

    while (($asrJob.State -eq "InProgress") -or ($asrJob.State -eq "NotStarted")) {
        sleep 10;
        $asrJob = Get-ASRJob -Job $asrJob
    }

    if ($asrJob.State -ne "Succeeded") {
        Write-Output "ERROR: ASR job failed."
        exit
    }
}

function Get-VNet {
    param([string]$vNetName, [string]$resourceGroupName)
    
    # Get the virtual network.
    $vnet = Get-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName
    $vnet.id
}

# Create a Recovery Services Vault.
Write-Output "Creating Recovery Services Vault"
$vault = New-AzRecoveryServicesVault -Name $vaultName -ResourceGroupName $drResourceGroupName -Location $drLocation

# Set the vault context for subsequent commands.
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

# Create the primary fabric.
$tempASRJob = New-ASRFabric -Azure -Location $primaryLocation -Name "primary"
Check-ASRJob $tempASRJob
$primaryFabric = Get-ASRFabric -Name "primary"

# Create the DR fabric.
$tempASRJob = New-ASRFabric -Azure -Location $drLocation -Name "dr"
Check-ASRJob $tempASRJob
$drFabric = Get-ASRFabric -Name "dr"

# Create a primary protection container.
Write-Output "Creating primary protection container"
$tempASRJob = New-AzRecoveryServicesAsrProtectionContainer -InputObject $primaryFabric -Name "primary"
Check-ASRJob $tempASRJob
$primaryProtectionContainer = Get-ASRProtectionContainer -Fabric $primaryFabric -Name "primary"

# Create a DR protection container.
Write-Output "Creating DR protection container"
$tempASRJob = New-AzRecoveryServicesAsrProtectionContainer -InputObject $drFabric -Name "dr"
Check-ASRJob $tempASRJob
$drProtectionContainer = Get-ASRProtectionContainer -Fabric $drFabric -Name "dr"

# Create a replication policy.
Write-Output "Creating replication policy"
$tempASRJob = New-ASRPolicy -AzureToAzure -Name "24-hour-retention-policy" `
    -RecoveryPointRetentionInHours 24 -ApplicationConsistentSnapshotFrequencyInHours 4
Check-ASRJob $tempASRJob
$replicationPolicy = Get-ASRPolicy -Name "24-hour-retention-policy"

# Create a protection container mapping for failover.
Write-Output "Creating protection container mapping for failover"
$tempASRJob = New-ASRProtectionContainerMapping -Name "primary-to-dr" -Policy $replicationPolicy `
    -PrimaryProtectionContainer $primaryProtectionContainer -RecoveryProtectionContainer $drProtectionContainer
Check-ASRJob $tempASRJob

# Create a protection container mapping for failback.
Write-Output "Creating protection container mapping for failback"
$tempASRJob = New-ASRProtectionContainerMapping -Name "dr-to-primary" -Policy $replicationPolicy `
    -PrimaryProtectionContainer $drProtectionContainer -RecoveryProtectionContainer $primaryProtectionContainer
Check-ASRJob $tempASRJob

# Get the primary network.
$primaryVNetId = Get-VNet -Name $primaryVNetName -ResourceGroupName $primaryResourceGroupName

# Get the DR network.
$drVNetId = Get-VNet -Name $drVnetName -ResourceGroupName $drResourceGroupName

# Create a network mapping for failover.
$tempASRJob = New-ASRNetworkMapping -AzureToAzure -Name "primary-to-dr" `
    -PrimaryFabric $primaryFabric -PrimaryAzureNetworkId $primaryVNetId `
    -RecoveryFabric $drFabric -RecoveryAzureNetworkId $drVNetId
Check-ASRJob $tempASRJob

# Create a network mapping for failback.
$tempASRJob = New-ASRNetworkMapping -AzureToAzure -Name "dr-to-primary" `
    -PrimaryFabric $drFabric -PrimaryAzureNetworkId $drVNetId `
    -RecoveryFabric $primaryFabric -RecoveryAzureNetworkId $primaryVNetId
Check-ASRJob $tempASRJob