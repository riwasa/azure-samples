@echo off

rem *****************************************************************************
rem
rem File:        01-RedisPremiumVNet.cmd
rem
rem Description: Creates a Virtual Network to use for Redis.
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

rem Create the Virtual Network.
az group deployment create --name "VNet" ^
  --resource-group %az_resource_group_name% ^
	--template-file "01-RedisPremiumVNet-azuredeploy.json" ^
	--parameters @"01-RedisPremiumVNet-azuredeploy.parameters.json"