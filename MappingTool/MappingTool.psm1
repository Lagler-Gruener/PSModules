
function Login-Azure()
{
    try 
    {
        if(-not (Get-Module Az.Accounts)) {
            Import-Module Az.Accounts
        }
            
        $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName 

        $passwd = ConvertTo-SecureString $servicePrincipalConnection.Secret -AsPlainText -Force
        $pscredential = New-Object System.Management.Automation.PSCredential($servicePrincipalConnection.AplicationID, $passwd)      

        Connect-AzAccount -ServicePrincipal `
                          -TenantId  $servicePrincipalConnection.TenantId`
                          -Credential $pscredential           
    }
    catch {
        Write-Error "Error in function Login-Azure. Error message: $($_.Exception.Message)"
    }
}

   
Function Get-Variable-Assets-UnEnc
{    
     $jsonmsg = @{
                    "resourceGroupWebhook" = "webhookrg"
                    "aadWebhook" = "webhookaad"
                    "connectionName" = "MappingToolSP"
                    "appresourcegroup"= Get-AutomationVariable -Name "AppResourceGroup"
                    "appstracc" = Get-AutomationVariable -Name "AppStorageAccountName"                    
                    "requiredRGTag" = Get-AutomationVariable -Name "AppRBACTag"
                    "onpremqueue" = Get-AutomationVariable -Name "OnPremMsgQueue"
                    "rolemappingtable" = Get-AutomationVariable -Name "RoleMappingTable"
                    "rbacconfigtable" = Get-AutomationVariable -Name "RBACConfigurationTable"
                    "azureRGPerm" = Get-AutomationVariable -Name "AppRBPermName"
                    "azureRolePerm" = Get-AutomationVariable -Name "AppAADRoleName" 
                    "automacc" = Get-AutomationVariable -Name "AppAutomationAccount"                    

                } | ConvertTo-Json

    return $jsonmsg
}