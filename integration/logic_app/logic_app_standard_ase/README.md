## App Service Environment
---

These files create a Virtual Network, and App Service Environment, and a Logic App (Standard).

1. Edit script_variables.ps1.

    * Change $location and $locationName to the desired region.
    * Change $resourceGroupName and $resourceGroupRawName to the desired name.
    * Save the file.  
      
2. Run virtual_network\virtual_network.ps1.

    * This file will create a Virtual Network with subnets for an Azure Bastion
      host, private endpoints, VMs, and the App Service Environment.
    * If you want to change the IP address space for the Virtual Network, the 
      size of any of the subnets, or add any subnets, edit the 
      virtual_network.parameters.json file before running the PowerShell script.

3. Run app_service_environment\app_service_environment.ps1.

    * This file will create an internal App Service Environment and optionally
      a Private DNS zone.
    * If you want to change creation of the Private DNS Zone or select
      parameters of the ASE, edit the app_service_environment.parameters.json file
      before running the PowerShell script.

4. Run storage_account\storage_account.ps1.

    * This file will create a Storage Account for the Logic App.
    * If you want to change the geo-replication type, edit the 
      storage_account.parameters.json file before running the PowerShell script.

5. Run application_insights\application_insights.ps1.

    * This file will create a Log Analytics Workspace and an Application Insights
      Component for Logic App telemetry.
    * If you want to change properties for either Log Analytics or Application
      Insights, edit the application_insights.parameters.json file before
      running the PowerShell script.

6. Run logic_app\logic_app.ps1.

    * This file will create a Logic App (Standard) in the App Service Environment.
    * If you want to change the SKU for the App Service Plan, edit the
      logic_app.parameters.json file before running the PowerShell script.