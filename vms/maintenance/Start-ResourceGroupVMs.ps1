<#
.SYNOPSIS
    Starts VMs in a Resource Group.

.DESCRIPTION
    Starts all Virtual Machines in a Resource Group.

.NOTES
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>

$resourceGroupName = Read-Host -Prompt "Enter the name of the Resource Group"

# Get all VMs in the Resource Group.
$vms = Get-AzVM -ResourceGroupName $resourceGroupName -Status

foreach ($vm in $vms) {
    if ($vm.PowerState -eq "VM deallocated") {
        Write-Output "Starting $($vm.Name)"
        Start-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName
    } else {
        Write-Output "$($vm.Name) already started"
    } 
}
