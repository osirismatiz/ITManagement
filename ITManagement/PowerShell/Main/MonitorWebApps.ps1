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
. ..\Modules\ModuleWebApps.ps1 

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$host.ui.rawui.windowtitle = $SCRIPTNAME
WriteLog "INFO" $SCRIPTNAME $SCRIPTNAME

function Main{
	#param([Parameter(Mandatory=$true)][string]$environmentName, [Parameter(Mandatory=$true)][string]$farmName)
    Try{ 
		$webAppsList = GetWebAppsList 
		
		#$credentials = Get-Credential -Credential "SLPAlRT_LAB2016@ACEINA"

		$computerName = $env:computername
		$arrayWebApps = @()
		foreach ($url in $webAppsList) { 
			Try {
				$webObject = New-Object -TypeName PSObject
				Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'Server Name' -Value $computerName
				
				Import-Module WebAdministration
				$HTTP_Request = [System.Net.WebRequest]::Create("$url");
				#$HTTP_Request.Credentials = New-Object System.Net.NetworkCredential('Administrator', 'Une2013.');
				$HTTP_Request.Credentials = New-Object System.Net.NetworkCredential('anonymous', 'password.');
				$HTTP_Response = $HTTP_Request.GetResponse();
				$HTTP_Status = [int]$HTTP_Response.StatusCode;
				$HTTP_Response.Close();

				If ($HTTP_Status -eq 200) {
					WriteLog "INFO" ("StatusCode: {0} {1}" -f $HTTP_Status, $url) $SCRIPTNAME
					Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'Status Code' -Value $HTTP_Status
				}
			}
			Catch [Net.WebException]
			{
				$errorCode = ([int]$_.Exception.Response.StatusCode)
				WriteLog "INFO" ("StatusCode: {0} {1}" -f $errorCode, $url) $SCRIPTNAME
				Add-Member -InputObject $webObject -MemberType NoteProperty -Force -Name 'Status Code' -Value $errorCode
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
		$htmlTable = $htmlTable -Replace '<td>500</td>', '<td style="background:#FDD;">500</td>'
		$htmlTable = $htmlTable -Replace '<td>401</td>', '<td style="background:#FFC107;">401</td>'
		$htmlTable = $htmlTable -Replace '<td>200</td>', '<td style="background:#DFD;">200</td>'
	}
	Catch{ 
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "[Main] $FailedItem. The error message was $ErrorMessage. ($PSItem.Exception.StackTrace)" $SCRIPTNAME  #-ErrorAction Continue
	}
	Finally{
		#Send Email
			SendMessage `
			"osirismatiz@createglobalweb.com" `
			"monicahidalgo@createglobalweb.com" `
			"Web Applications Monitor $computerName - [$computerIP]" `
			"$htmlTable"
	}
}

Main 
