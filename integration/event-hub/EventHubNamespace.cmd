@echo off

rem *****************************************************************************
rem
rem File:        EventHubNamespace.cmd
rem
rem Description: Creates an Event Hub Namespace.
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

rem Create the Event Hub Namespace.
az group deployment create --name "EventHubNS" ^
  --resource-group %az_resource_group_name% ^
	--template-file "EventHubNamespace-azuredeploy.json" ^
	--parameters @"EventHubNamespace-azuredeploy.parameters.json"