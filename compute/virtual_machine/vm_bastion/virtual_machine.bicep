// *****************************************************************************
//
// File:        virtual_machine.bicep
//
// Description: Creates a Virtual Machine.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// *****************************************************************************

@description('Optional. When specifying a Windows Virtual Machine, this value should be passed.')
@secure()
param adminPassword string

@description('Required. Administrator username.')
@secure()
param adminUsername string

@description('The time at which the VM should be automatically shutdown.')
param autoShutdownTime string

@description('The time zone for the VM auto shutdown time.')
param autoShutdownTimeZone string

@description('The OS image reference.')
param imageReference object

@description('The location of the resources.')
param location string

@description('The OS disk.')
param osDisk object

@description('The computer name of the Virtual Machine.')
param virtualMachineComputerName string

@description('The name of the Virtual Machine.')
param virtualMachineName string

@description('The name of the Virtual Network')
param virtualNetworkName string

@description('The size of the Virtual Machine.')
param vmSize string

// Create a Network Interface.
resource networkInterface 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: '${virtualMachineName}-nic'
  location: location
  properties: {
    enableAcceleratedNetworking: true
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id:  resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, 'vms')
          }
        }
      }
    ]
  }
}

// Create a Virtual Machine.
resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: virtualMachineName
  location: location
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: virtualMachineComputerName
      adminPassword: adminPassword
      adminUsername: adminUsername
      windowsConfiguration: {
        enableAutomaticUpdates: true
        patchSettings: {
          enableHotpatching: false
          patchMode: 'AutomaticByOS'
        }
        provisionVMAgent: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    storageProfile: {
      imageReference: imageReference
      osDisk: {
        name: '${virtualMachineName}-disk-os-01'
        createOption: osDisk.createOption
        deleteOption: 'Delete'
        diskSizeGB: osDisk.diskSizeGB
        caching: osDisk.caching
        managedDisk: {
          storageAccountType: osDisk.managedDisk.storageAccountType
        }
      }
    }
  }
}

// Create a shutdown schedule. Note the schedule name must be exactly as shown, 
// in the same Subscription and Resource Group as the VM.
resource shutdownSchedule 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${virtualMachineName}'
  location: location
  properties: {
    dailyRecurrence: {
      time: autoShutdownTime
    }
    status: 'Enabled'
    targetResourceId: virtualMachine.id
    taskType: 'ComputeVmShutdownTask'
    timeZoneId: autoShutdownTimeZone
  }
}
