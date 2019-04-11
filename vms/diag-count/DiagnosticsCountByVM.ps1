# *****************************************************************************
#
# File:        DiagnosticsCountByVM.ps1
#
# Description: Counts diagnostics rows per VM.
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

#Install-Module AzureRmStorageTable

$resourceGroupName = "Mag-Diag"
$storageAccountName = "rimmagdiag"
$tableName = "WADPerformanceCountersTable"

$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName
    
$context = $storageAccount.Context

$storageTable = Get-AzureStorageTable –Name $tableName –Context $context

$rows = Get-AzureStorageTableRowAll -table $storageTable

$total = $rows.Count
Write-Host "Total rows: $total"

$current = 0
$count = 0
$vmCount = @{}

foreach ($row in $rows){
    $count = $vmCount[$row.RoleInstance]
    if ($count -eq $null) {
        $vmCount[$row.RoleInstance] = 1
    }
    else
    {
        $vmCount[$row.RoleInstance] = $count + 1
    }

    $current = $current + 1
    if ($current % 100 -eq 0)
    {
        Write-Host "$current of $total"
    }
}

Write-Host "Total by VM:"
$vmCount
