@echo off

rem *****************************************************************************
rem
rem File:        Redis.cmd
rem
rem Description: Creates a Redis cache.
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

rem Create the Redis cache.
az group deployment create --name "Redis" ^
  --resource-group %az_resource_group_name% ^
	--template-file "Redis-azuredeploy.json" ^
	--parameters @"Redis-azuredeploy.parameters.json"


	az network watcher configure --resource-group NetworkWatcherRG --locations westcentralus --enabled