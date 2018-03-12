# *****************************************************************************
#
# File:        GetBackupItemsPerPolicy.ps1
#
# Description: Gets backup items for each backup policy in a Recovery Services
#              vault.
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

$resourceGroupName = "Mag-Backup"
$vaultName = "Mag-Backup-rsv"

# Get Recovery Services Vault.
$vault = Get-AzureRmRecoveryServicesVault -ResourceGroupName $resourceGroupName -Name $vaultName

# Set the Recovery Services Vault context.
Set-AzureRmRecoveryServicesVaultContext -Vault $vault

# Get the names of all backup policies.
$names = Get-AzureRmRecoveryServicesBackupProtectionPolicy | select Name

foreach ($name in $names)
{
    Write-Host $name.Name

    # Get the backup items for each backup policy.
    $items = Get-AzureRmRecoveryServicesBackupItem -BackupManagementType AzureVM -WorkloadType AzureVM | Where-Object {$_.ProtectionPolicyName -eq $name.Name}
    
    foreach ($item in $items)
    {
        Write-Host $item.Name
    }
}
