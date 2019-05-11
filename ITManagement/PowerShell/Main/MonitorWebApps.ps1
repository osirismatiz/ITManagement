<#
    Date       : 2019-03-07
    Author     : Osiris Matiz Zapata
    Name       : ChangeServicePassword
    Description: Change passwords to all services list 
#>

#[CmdletBinding()]
#param ([Parameter(Mandatory=$true)][string]$Environment, [Parameter(Mandatory=$true)][string]$Farm)

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Get-ExecutionPolicy

[System.GC]::Collect()
Clear-Host

###Import Modules
. ..\Modules\ModuleXML.ps1 
. ..\Modules\ModuleLogs.ps1 
. ..\Modules\ModuleHTML.ps1 
. ..\Modules\ModuleSendEmail.ps1 

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$host.ui.rawui.windowtitle = $SCRIPTNAME
WriteLog "INFO" $SCRIPTNAME $SCRIPTNAME

function Main{
    Try{ 
		$webAppsList = GetWebAppsList 
		
		#$credentials = Get-Credential -Credential "SLPAlRT_LAB2016@ACEINA"
		if(-not(Get-Module -name "ServerManager")) {Import-Module ServerManager; Add-WindowsFeature Web-Scripting-Tools} 
		if(-not(Get-Module -name "WebAdministration")) {Import-Module "WebAdministration"} 

		$computerName = $env:computername
		$arrayWebApps = @()
		
		foreach ($url in $webAppsList) { 
			Try {
				$webObject = New-Object -TypeName PSObject
				Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'Server Name' -Value $computerName
				
				$HTTP_Request = [System.Net.WebRequest]::Create("$url");
				#$HTTP_Request.Credentials = New-Object System.Net.NetworkCredential('Administrator', 'Une2013.');
				$HTTP_Request.Credentials = New-Object System.Net.NetworkCredential('anonymous', 'password.');
				$HTTP_Response = $HTTP_Request.GetResponse();
				$HTTP_Status = [int]$HTTP_Response.StatusCode;
				$HTTP_Response.Close();

				If ($HTTP_Status -eq 200) {
					$statusDescription = $HTTPStatusCodes.Get_Item($HTTP_Status)
					WriteLog "INFO" ("StatusCode:{0} StatusDescription:{1} URI:{2}" -f $HTTP_Status, $statusDescription, $url) $SCRIPTNAME
					Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'Status Code' -Value $HTTP_Status
					Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'Status Description' -Value $statusDescription
				}
			}
			Catch [Net.WebException]
			{
				$errorCode = ([int]$_.Exception.Response.StatusCode)
				$statusDescription = $HTTPStatusCodes.Get_Item($errorCode)
				WriteLog "INFO" ("StatusCode:{0} StatusDescription:{1} URI:{2}" -f $errorCode, $statusDescription, $url) $SCRIPTNAME
				Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'Status Code' -Value $errorCode
				Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'Status Description' -Value $statusDescription
			}
			Finally{
				Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'URI' -Value $url
				$arrayWebApps += $webObject
			}
		}
		
		#$arrayWebApps | Format-Table -AutoSize 
		$computerIP = ((Test-Connection -ComputerName $env:computername -count 1).ipv4address.IPAddressToString)
		$htmlTable = CreateObjectToHtmlTableGreenStyle $arrayWebApps "Web Applications Monitor $computerName - [$computerIP]"
		
		# Highlight Status codes
		#$htmlTable = $htmlTable -Replace '<td>503</td>', '<td style="text-align: center; background:#FF3333;">503</td>'
		$htmlTable = $htmlTable -Replace '<td>5(.*?)', '<td style="text-align: center; background:#FF3333;">5' #ERROR
		$htmlTable = $htmlTable -Replace '<td>4(.*?)', '<td style="text-align: center; background:#FFD700;">4' #WARNING
		$htmlTable = $htmlTable -Replace '<td>2(.*?)', '<td style="text-align: center; background:#228B22;">2' #OK
		
		$htmlTable | Out-File -FilePath ('..\{0}_report.html' -f $SCRIPTNAME) -Force 
	}
	Catch{ 
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "[Main] $FailedItem. The error message was $ErrorMessage. ($PSItem.Exception.StackTrace)" $SCRIPTNAME 
	}
	Finally{
		<### Send Email
			SendMessageNoSSL `
			"noreply@chubb.com" `
			"osiris.matiz2@chubb.com" `
			"Web Applications Monitor $computerName - [$computerIP]" `
			"$htmlTable"#>
	}
}

Main 
