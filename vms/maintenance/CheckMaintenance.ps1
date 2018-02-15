<#
.SYNOPSIS
	Checks for VMs that require maintenance in the specified Subscription.
.NOTES
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
#>

$subscriptionId = "55eb90af-e6e7-4061-baf0-cf30e260a0b7"

function MaintenanceIterator
{
    Select-AzureRmSubscription -SubscriptionId $args[0]

    $rgList= Get-AzureRmResourceGroup 

    for ($rgIdx=0; $rgIdx -lt $rgList.Length; $rgIdx++)
    {
        $rg = $rgList[$rgIdx]    
            
        $vmList = Get-AzureRmVM -ResourceGroupName $rg.ResourceGroupName 

        for ($vmIdx=0; $vmIdx -lt $vmList.Length; $vmIdx++)
        {
            $vm = $vmList[$vmIdx]

            $vmDetails = Get-AzureRmVM -ResourceGroupName $rg.ResourceGroupName -Name $vm.Name -Status

            if ($vmDetails.MaintenanceRedeployStatus)
            {
                Write-Output "VM: $($vmDetails.Name) IsCustomerInitiatedMaintenanceAllowed: $($vmDetails.MaintenanceRedeployStatus.IsCustomerInitiatedMaintenanceAllowed) $($vmDetails.MaintenanceRedeployStatus.LastOperationMessage)"               
            }
        }
    }
}

MaintenanceIterator $subscriptionId
