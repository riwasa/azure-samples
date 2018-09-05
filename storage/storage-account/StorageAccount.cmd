@echo off

rem *****************************************************************************
rem
rem File:        StorageAcount.cmd
rem
rem Description: Creates a Storage Account.
rem
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem SOFTWARE.
rem 
rem *****************************************************************************

rem Prompt for the name of the Resource Group.
echo Please enter the name of the existing Resource Group to use:
set /p az_resource_group_name=""

rem Create the Storage Account.
for /F "usebackq tokens=*" %%d in (`az group deployment create --name "Storage" ^
  --resource-group %az_resource_group_name% ^
	--template-file "StorageAccount-azuredeploy.json" ^
  --output tsv ^
  --query "properties.outputs.storageAccountName.value" ^
	--parameters @"StorageAccount-azuredeploy.parameters.json"`
  ) do (
    set az_storage_account_name=%%d
  )

rem Get the Storage Account.
set az_storage_account_key=""
set az_command="az storage account keys list --resource-group %az_resource_group_name% --account-name %az_storage_account_name% --output tsv"

for /F "usebackq tokens=3" %%d in (`%az_command%`) do (
  set az_storage_account_key=%%d 
  goto :continue
)

:continue

rem Set environment variables for later storage commands.
set AZURE_STORAGE_ACCESS_KEY=%az_storage_account_key% 
set AZURE_STORAGE_ACCOUNT=%az_storage_account_name%
