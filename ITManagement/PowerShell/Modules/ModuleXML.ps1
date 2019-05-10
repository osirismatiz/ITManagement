### ------------------------------------------------------------------
#$CURRENTFOLDER = Split-Path -parent $MyInvocation.MyCommand.Path
$CURRENTFOLDER = Split-Path -parent $MyInvocation.ScriptName
Write-Host ("`nCurrent Folder is:'{0}'" -f $CURRENTFOLDER) -Fore black -Back gray
cd $CURRENTFOLDER

### ------------------------------------------------------------------
function GetConfigContent{
	param([Parameter(Mandatory=$true)][string]$pathConfig)

    Try { 
        [Xml]$xmlContent = [Xml](Get-Content -Path "$pathConfig" -Encoding UTF8)
        Write-Output $xmlContent
    }
    Catch { 
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "GetConfigContent: $FailedItem. The error message was $ErrorMessage" 
    }
}

function GetXmlNodes{
	param([Parameter(Mandatory=$true)][Xml]$xmlDocument, [Parameter(Mandatory=$true)][String]$xPath, [string]$ns)

    $nameSpace = @{tns = $ns}    
    $params = @{ 'Xml' = $xmlDocument; 'XPath' = $xPath }
    if(![string]::IsNullOrEmpty($ns)) { $params.Add('Namespace', $nameSpace) }
    $xmlContent = Select-Xml @params
    
    Write-Output $xmlContent
}

### ------------------------------------------------------------------
function GetWebAppsList{
    [string]$nameSpace = ""
    [string]$xPath = "/WebApps/WebApp"
    $nodeWebApps = GetXmlNodes $CONFIGWEBAPPS $xPath $nameSpace
    Write-Output $nodeWebApps
}

function GetServersList{
    [string]$nameSpace = ""
    [string]$xPath = "/Servers/Server"
    $nodeWebApps = GetXmlNodes $CONFIGSERVERS $xPath $nameSpace
    Write-Output $nodeWebApps
}


### ------------------------------------------------------------------
$WEBAPPSCONFIGPATH = "$CURRENTFOLDER\..\Config\WebApps.config"
$CONFIGWEBAPPS = GetConfigContent $WEBAPPSCONFIGPATH

$SERVERSCONFIGPATH = "$CURRENTFOLDER\..\Config\Servers.config"
$CONFIGSERVERS = GetConfigContent $SERVERSCONFIGPATH


