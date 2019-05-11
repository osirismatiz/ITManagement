Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Get-ExecutionPolicy

Set-DtcNetworkSetting -DtcName "Local" -AuthenticationLevel "NoAuth" -InboundTransactionsEnabled $true -OutboundTransactionsEnabled $true -RemoteClientAccessEnabled $true -RemoteAdministrationAccessEnabled $true -Confirm:$false
Get-DtcNetworkSetting -DtcName "Local"

Stop-Service MSDTC
Start-Service MSDTC

Limit-EventLog -Logname "Application" -ComputerName . -MaximumSize 100MB

Import-Module WebAdministration 

# Get-WindowsOptionalFeature -Online | where FeatureName -like 'IIS-*' | where State -eq 'Enabled' | Select-Object FeatureName

DISM /Online /Enable-Feature /FeatureName:IIS-WebServerRole
DISM /Online /Enable-Feature /FeatureName:IIS-WebServer
DISM /Online /Enable-Feature /FeatureName:IIS-CommonHttpFeatures
DISM /Online /Enable-Feature /FeatureName:IIS-DefaultDocument
DISM /Online /Enable-Feature /FeatureName:IIS-DirectoryBrowsing
DISM /Online /Enable-Feature /FeatureName:IIS-HttpErrors
DISM /Online /Enable-Feature /FeatureName:IIS-StaticContent
DISM /Online /Enable-Feature /FeatureName:IIS-HttpRedirect
DISM /Online /Enable-Feature /FeatureName:IIS-WebDAV

DISM /Online /Enable-Feature /FeatureName:IIS-Security
DISM /Online /Enable-Feature /FeatureName:IIS-RequestFiltering

DISM /Online /Enable-Feature /FeatureName:IIS-ApplicationDevelopment
DISM /Online /Enable-Feature /FeatureName:IIS-NetFxExtensibility /All
DISM /Online /Enable-Feature /FeatureName:IIS-NetFxExtensibility45 /All
DISM /Online /Enable-Feature /FeatureName:IIS-ISAPIExtensions
DISM /Online /Enable-Feature /FeatureName:IIS-ISAPIFilter
DISM /Online /Enable-Feature /FeatureName:IIS-ASPNET45 /All

DISM /Online /Enable-Feature /FeatureName:IIS-HealthAndDiagnostics
DISM /Online /Enable-Feature /FeatureName:IIS-HttpLogging

DISM /Online /Enable-Feature /FeatureName:IIS-CertProvider
DISM /Online /Enable-Feature /FeatureName:IIS-BasicAuthentication
DISM /Online /Enable-Feature /FeatureName:IIS-WindowsAuthentication
DISM /Online /Enable-Feature /FeatureName:IIS-DigestAuthentication
DISM /Online /Enable-Feature /FeatureName:IIS-ClientCertificateMappingAuthentication
DISM /Online /Enable-Feature /FeatureName:IIS-IISCertificateMappingAuthentication
DISM /Online /Enable-Feature /FeatureName:IIS-URLAuthorization
DISM /Online /Enable-Feature /FeatureName:IIS-IPSecurity
DISM /Online /Enable-Feature /FeatureName:IIS-Performance
DISM /Online /Enable-Feature /FeatureName:IIS-HttpCompressionStatic
DISM /Online /Enable-Feature /FeatureName:IIS-WebServerManagementTools
DISM /Online /Enable-Feature /FeatureName:IIS-ManagementConsole
DISM /Online /Enable-Feature /FeatureName:IIS-LegacySnapIn /All
DISM /Online /Enable-Feature /FeatureName:IIS-ManagementScriptingTools
DISM /Online /Enable-Feature /FeatureName:IIS-ManagementService /All
DISM /Online /Enable-Feature /FeatureName:IIS-IIS6ManagementCompatibility
DISM /Online /Enable-Feature /FeatureName:IIS-Metabase
DISM /Online /Enable-Feature /FeatureName:IIS-WMICompatibility
DISM /Online /Enable-Feature /FeatureName:IIS-LegacyScripts

DISM /Online /Enable-Feature /FeatureName:NetFx4ServerFeatures
DISM /Online /Enable-Feature /FeatureName:NetFx4
DISM /Online /Enable-Feature /FeatureName:NetFx4Extended-ASPNET45
DISM /Online /Enable-Feature /FeatureName:NetFx3ServerFeatures
DISM /Online /Enable-Feature /FeatureName:NetFx3

DISM /Online /Enable-Feature /FeatureName:TelnetClient

DISM /Online /Enable-Feature /FeatureName:WCF-Services45
DISM /Online /Enable-Feature /FeatureName:WCF-HTTP-Activation /All
DISM /Online /Enable-Feature /FeatureName:WCF-HTTP-Activation45 /All
DISM /Online /Enable-Feature /FeatureName:WCF-TCP-Activation45 /All
DISM /Online /Enable-Feature /FeatureName:WCF-Pipe-Activation45 /All
DISM /Online /Enable-Feature /FeatureName:WCF-MSMQ-Activation45 /All
DISM /Online /Enable-Feature /FeatureName:WCF-TCP-PortSharing45

DISM /Online /Enable-Feature /FeatureName:Windows-Identity-Foundation

cscript c:\inetpub\adminscripts\adsutil.vbs SET W3SVC/AppPools/Enable32bitAppOnWin64 1

#### IIS HTTP Error 404.17 - Not Found
"C:\Windows\Microsoft.NET\Framework\v3.0\Windows Communication Foundation\ServiceModelReg.exe" -i
IISRESET /restart
#### Reconfigure APPPool .Net CLR Version

#%windir%\system32\inetsrv\appcmd.exe set app "Default Web Site/WcfServiceLibrary" /enabledProtocols:http,net.tcp


Start-Process -Wait -FilePath "F:\ITManagement\Installers\npp.7.6.6.Installer.exe" -ArgumentList "/S" -PassThru
Start-Process -Wait -FilePath "F:\ITManagement\Installers\Update for Visual C++ 2013 and Visual C++ Redistributable Package.exe" -ArgumentList "/S" -PassThru
Start-Process -Wait -FilePath "F:\ITManagement\Installers\SqlXml 4.0 Service Pack 1 (SP1).msi" -ArgumentList "/qn" -PassThru

Start-Process -Wait -FilePath "F:\ITManagement\Installers\Enterprise Library 5.0.msi" -ArgumentList "/qn" -PassThru
Start-Process -Wait -FilePath "F:\ITManagement\Installers\Microsoft Report Viewer Redistributable 2008.exe" -ArgumentList "/S" -PassThru


Start-Process -Wait -FilePath "F:\ITManagement\Installers\Enterprise Library 5\Enterprise Library 5.0.msi" -ArgumentList "/qn" -PassThru
Start-Process -Wait -FilePath "F:\ITManagement\Installers\Microsoft Report Viewer Redistributable 2008\ReportViewer.exe" -ArgumentList "/S" -PassThru

### After SQL Server 2016 installation
$NamedPipesProtocol = Get-WmiObject -namespace 'root\Microsoft\SqlServer\MSSQL\BIZTALK_SIT_2016' -class ClientNetworkProtocol -filter "ProtocolName='np'" 
$NamedPipesProtocol.setdisable()

[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") 
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")  
# Function to Enable or Disable a SQL Server Network Protocol 
function ChangeSQLProtocolStatus($server,$instance,$protocol,$enable){ 
    $smo = 'Microsoft.SqlServer.Management.Smo.' 
    $wmi = new-object ($smo + 'Wmi.ManagedComputer') 
    $singleWmi = $wmi | where {$_.Name -eq $server}   
    $uri = "ManagedComputer[@Name='$server']/ServerInstance[@Name='$instance']/ServerProtocol[@Name='$protocol']" 
    $protocol = $singleWmi.GetSmoObject($uri) 
    $protocol.IsEnabled = $enable 
    $protocol.Alter()     
    $protocol 
} 

# Enable TCP/IP SQL Server Network Protocol 
ChangeSQLProtocolStatus -server "LAUSD-WBZT0055" -instance "BIZTALK_SIT_2016" -protocol "TCP" -enable $true 
# Enable Named Pipes SQL Server Network Protocol 
ChangeSQLProtocolStatus -server "LAUSD-WBZT0055" -instance "BIZTALK_SIT_2016" -protocol "NP" -enable $true 
# Disable Shared Memory SQL Server Network Protocol 
ChangeSQLProtocolStatus -server "LAUSD-WBZT0055" -instance "BIZTALK_SIT_2016" -protocol "SM" -enable $false 
 
Start-Process -Wait -FilePath "F:\ITManagement\Installers\BizTalk CU3\BTS2016-KB4039664-ENU.exe" -ArgumentList "/S" -PassThru

<#
#NODO 3 SQL Server 
#BIZTALK_SIT_2016

#LAUSD-WBZT0052\BIZTALK_SIT_2016
User: sa
B1z3nvd3v#

MasterSecret 
M4st3rS3cr3t+

ACEINA\SLPISOHST_DEV2016
ACEINA\SLPRULE_DEV2016
ACEINA\SLPHOST_DEV2016
B1z3nvd3v#

ACEINA\SLPSSO_DEV2016
5s0b1zd@nv

ACEINA\GRP_LA_PPT_BTS SSO Affi Admins
ACEINA\GRP_LA_PPT_BTS SSO Admins

ACEINA\GRP_LA_PPT_BTS Administrators
ACEINA\GRP_LA_PPT_BTS App Users
ACEINA\GRP_LA_PPT_BTS Operators
ACEINA\GRP_LA_PPT_BTS B2B Operators
ACEINA\GRP_LA_PPT_BTS Iso Host Users

ACEINA\ESB_Portal_Operators

http://172.25.104.180/ESB.Portal/Home/HomePage.aspx

Managing Internet Explorer Enhanced Security Configuration.

# Load IIS module:
Import-Module WebAdministration
# Set a name of the site we want to recycle the pool for:
$site = "Default Web Site"
# Get pool name by the site name:
$pool = (Get-Item "IIS:\Sites\$site"| Select-Object applicationPool).applicationPool
# Recycle the application pool:
Restart-WebAppPool $pool
Restart-WebAppPool 'EsbPortalNetworkAppPool'


SERVIDORES DEV MEXICO
LAUSD-WBZT0050: 172.25.104.229
LAUSD-WBZT0051: 172.25.104.230
LAUSD-WBZT0052: 172.25.104.231

SERVIDORES SIT MEXICO
LAUST-WBZT0053 - 172.25.104.125
LAUST-WBZT0054 - 172.25.104.140
LAUST-WBZT0055 - 172.25.104.180
#>

"%WINDIR%\Microsoft.Net\Framework\v4.0.30319\aspnet_regiis" –i –enable
"%WINDIR%\Microsoft.Net\Framework\v4.0.30319\ServiceModelReg.exe" -r

