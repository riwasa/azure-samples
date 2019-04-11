# *****************************************************************************
#
# File:        00-ScriptVariables.ps1
#
# Description: Sets variables used in other scripts.
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

# Azure region for the primary environment.
$primaryLocation = "eastus"

# Resource Group name for the primary environment.
$primaryResourceGroupName = "Demo-Primary"

# Azure region for the DR environment.
$drLocation = "eastus2"

# Resource Group name for the DR environment.
$drResourceGroupName = "Demo-DR"

# Get a password to use for the local admin account on VMs.
function Get-Password {
    $password = Read-Host 'Please enter a password to use for the local admin account on the VM' -AsSecureString
    $confirmPassword = Read-Host 'Please re-enter the password to confirm' -AsSecureString

    $passwordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
    $confirmPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPassword))
 
    if ($passwordText -ceq $confirmPasswordText) {
        $password
     } else {
        Write-Host "ERROR: Passwords do not match"
        exit
    }
}
